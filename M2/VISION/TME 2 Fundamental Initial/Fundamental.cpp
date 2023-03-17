// Imagine++ project
// Project:  Fundamental
// Author:   Pascal Monasse
// Date:     2013/10/08

#include "./Imagine/Features.h"
#include <Imagine/Graphics.h>
#include <Imagine/LinAlg.h>
#include <vector>
#include <cstdlib>
#include <ctime>
#include<cmath>
#include <stdlib.h> 
#include <algorithm>

using namespace Imagine;
using namespace std;

static const double MAX_ITER = 100000.0;
static const float BETA = 0.01f; // Probability of failure
static const float LOGBETA = logf(BETA);

struct Match {
    float x1, y1, x2, y2;
};

// Display SIFT points and fill vector of point correspondences
void algoSIFT(Image<Color,2> I1, Image<Color,2> I2,
              vector<Match>& matches) {
    // Find interest points
    SIFTDetector D;
    D.setFirstOctave(-1);
    Array<SIFTDetector::Feature> feats1 = D.run(I1);
    drawFeatures(feats1, Coords<2>(0,0));
    cout << "Im1: " << feats1.size() << flush;
    Array<SIFTDetector::Feature> feats2 = D.run(I2);
    drawFeatures(feats2, Coords<2>(I1.width(),0));
    cout << " Im2: " << feats2.size() << flush;

    const double MAX_DISTANCE = 100.0*100.0;
    for(size_t i=0; i < feats1.size(); i++) {
        SIFTDetector::Feature f1=feats1[i];
        for(size_t j=0; j < feats2.size(); j++) {
            double d = squaredDist(f1.desc, feats2[j].desc);
            if(d < MAX_DISTANCE) {
                Match m;
                m.x1 = f1.pos.x();
                m.y1 = f1.pos.y();
                m.x2 = feats2[j].pos.x();
                m.y2 = feats2[j].pos.y();
                matches.push_back(m);
            }
        }
    }
}

// RANSAC algorithm to compute F from point matches (8-point algorithm)
// Parameter matches is filtered to keep only inliers as output.
FMatrix<float,3,3> computeF(vector<Match>& matches) {
    const float distMax = 1.5f; // Pixel error for inlier/outlier discrimination
    FMatrix<float,3,3> bestF;
    cout.precision(30);
    srand (time(NULL));
    int best_performance = 0;
    vector<int> bestInliers;
    int niter = 10000.0f;
    float dyn = 100000.0f; 
    int i, lrm = 0;
    
    // --------------- TODO ------------
    // DO NOT FORGET NORMALIZATION OF POINTS

   
   // NORMALIZATION  
    FMatrix<float, 3, 3> N; 
    N(0, 0) = 0.001f; N(0, 1) = 0; N(0, 2) = 0;
    N(1, 0) = 0; N(1, 1) = 0.001f; N(1, 2) = 0; 
    N(2, 0) = 0; N(2, 1) = 0; N(2, 2) = 1.0f;
    
    cout<<"Beginning of RANSAC algorithm.."<<endl;
    

    //***------------------------------- RANSAC LOOP --------------------------------***
    while(lrm<niter && lrm<MAX_ITER) 
    {
        
        cout<<"("<<lrm<<"/"<<niter<<")"<<endl;
        int size = 8;
        FMatrix<float, 9, 9> A;
        FVector<float, 3> v1, v2;
        vector<Match> matchestmp(8);
        int randnu;
        vector<int> chosen;
        for(i=0; i<size; i++)
        {
            do {
                randnu =  rand() % matches.size() + 0;
            } while(count(chosen.begin(), chosen.end(), randnu));
            chosen.push_back(randnu);
            v1[0] = matches.at(randnu).x1; v1[1] = matches.at(randnu).y1 ; v1[2] = 1;
            v2[0] = matches.at(randnu).x2; v2[1] = matches.at(randnu).y2 ; v2[2] = 1;
            
            v1 = N*v1;
            v2 = N*v2;
            
            matchestmp[i].x1 = v1[0];   matchestmp[i].y1 = v1[1];
            matchestmp[i].x2 = v2[0];   matchestmp[i].y2 = v2[1];
            // cout<<"before : "<<matches.at(i).x1<<","<<matches.at(i).y1<<", "<<matches.at(i).x2<<", "<<matches.at(i).y2<<endl;
            // cout<<"after : "<<matchestmp[i]<<endl;
        }

        for(i=0; i<size; i++)
        {
            A(i, 0) = matchestmp[i].x1*matchestmp[i].x2;
            A(i, 1) = matchestmp[i].x1*matchestmp[i].y2;
            A(i, 2) = matchestmp[i].x1;
            A(i, 3) = matchestmp[i].y1*matchestmp[i].x2;
            A(i, 4) = matchestmp[i].y1*matchestmp[i].y2;
            A(i, 5) = matchestmp[i].y1;
            A(i, 6) = matchestmp[i].x2;
            A(i, 7) = matchestmp[i].y2;
            A(i, 8) = 1;

        }

        for(int i = 0; i < 9;i++)
        {
        A(8,i) = 0;
        }
        // cout<<"Matrix A :"<<endl;
        // cout<<A<<endl;

        // A = U * D * V
        FMatrix<float, 9, 9> U;
        FVector<float, 9> D;
        FMatrix<float, 9, 9> Vt;
        svd(A, U, D, Vt) ;  
        /*
        cout<<"U ="<<endl;
        cout<<U;
        cout<<endl;
        cout<<"D ="<<endl;
        cout<<D;
        cout<<endl;
        cout<<"V^T ="<<endl;
        cout<<Vt;
        cout<<endl;
        */

        FMatrix<float, 3, 3> F;
        F(0, 0) = Vt(8, 0); F(0, 1) = Vt(8, 1); F(0, 2) = Vt(8, 2);
        F(1, 0) = Vt(8, 3); F(1, 1) = Vt(8, 4); F(1, 2) = Vt(8, 5);
        F(2, 0) = Vt(8, 6); F(2, 1) = Vt(8, 7); F(2, 2) = Vt(8, 8); 


        // *------------- Reducing Rank to 2 by setting least value of Df to 0 ----------------*
        FMatrix<float, 3, 3> Uf;
        FVector<float, 3> Df;
        FMatrix<float, 3, 3> Vft;
        svd(F, Uf, Df, Vft) ;  
        /*
        cout<<"Uf ="<<endl;
        cout<<Uf;
        cout<<endl;
        cout<<"Df ="<<endl;
        cout<<Df;
        cout<<endl;
        cout<<"Vf^T ="<<endl;
        cout<<Vft;
        cout<<endl;
        */

        FMatrix<float,3,3> Df_prime;
        Df_prime.fill(0);
        Df_prime(0, 0) = Df[0];
        Df_prime(0, 1) = Df[1];
        F = Uf*Df_prime*Vft;


        //***--------------------- LAST STEP OF DE-NORMALIZATIOn --------------------------***
        F = N*F*N;
        float distance;
        long double number_inliers=0, number_outliers=0;
    
        int pr = matches.size();
        int training_size = min(pr, 1000);


        vector<int> Inliers;
        for(int i=0;i<training_size;i++)
        {
            //***------------------------- SAMPSON DISTANCE ----------------------------***
            v1[0] = matches.at(i).x1; v1[1] = matches.at(i).y1 ; v1[2] = 1;
            v2[0] = matches.at(i).x2; v2[1] = matches.at(i).y2 ; v2[2] = 1;
            FVector<float, 3> tmp = transpose(F)*v1;

            distance = abs( v2*tmp )   /   sqrt( pow(tmp[0], 2.0 )  +   pow( tmp[1], 2.0 )  );
            if(distance<distMax)
            {
                Inliers.push_back(i);
                number_inliers++;            
            }
            else
            {
                number_outliers++;
            }
        }
        
        cout<<"Number of inliers = "<<number_inliers<<endl;
        cout<<"Number of outliers = "<<number_outliers<<endl;
        cout<<"BEST PERFORMANCE NUMBER INLIERS = "<<best_performance<<endl;
        lrm++;
        if (number_inliers > best_performance)
        {
            best_performance = number_inliers;
                bestInliers = Inliers;
                bestF = F;
                float ratio = 1.0f*number_inliers/(1.0f*matches.size());
                dyn = (LOGBETA/logf(1-pow(ratio,8)));

                if (dyn*logf(1-pow(ratio,8))<LOGBETA)
                {
                    niter = (int)dyn;
                }
            }
    
    }
    cout<<"BEST PERFORMANCE NUMBER INLIERS = "<<best_performance<<endl;
    
    // Updating matches with inliers only
    vector<Match> all=matches;
    matches.clear();
    for(size_t i=0; i<bestInliers.size(); i++)
    {
        matches.push_back(all[bestInliers[i]]);
    }

    // ***------------------------ LEAST SQUARE REFINEMENT -------------------***

    Matrix<float> LS(bestInliers.size(),9);
    FVector<float,3> v;

    for (size_t i=0; i<matches.size(); i++)
    {
        Match m;
        v[0] = matches[i].x1;   v[1] = matches[i].y1;   v[2] = 1.0f;

        v[0] /= 1000.0f;    v[1] /= 1000.0f;
        m.x1 = v[0];        m.y1 = v[1];

        v[0] = matches[i].x2;   v[1] = matches[i].y2;
        v[0] /= 1000.0f;        v[1] /= 1000.0f;
        m.x2 = v[0];            m.y2 = v[1];

        LS(i,0) = m.x1*m.x2;    LS(i,3) = m.x2*m.y1;    LS(i,6) = m.x2;
        LS(i,1) = m.x1*m.y2;    LS(i,4) = m.y1*m.y2;    LS(i,7) = m.y2;
        LS(i,2) = m.x1;         LS(i,5) = m.y1;         LS(i,8) = 1;  
    }


    // ***----------------------- SVD -----------------------***
    Vector<float> S(9);                      
    Matrix<float> U(matches.size(),matches.size());
    Matrix<float> Vt(9,9);
    svd(LS,U,S,Vt,false);

    bestF(0,0) = Vt(8,0);   bestF(1,0) = Vt(8,3);   bestF(2,0) = Vt(8,6);
    bestF(0,1) = Vt(8,1);   bestF(1,1) = Vt(8,4);   bestF(2,1) = Vt(8,7);
    bestF(0,2) = Vt(8,2);   bestF(1,2) = Vt(8,5);   bestF(2,2) = Vt(8,8);
    
    // ***----------------------- SVD -----------------------***
    FVector<float, 3> S2;    
    FMatrix<float,3,3> U2, V2t;
    FMatrix<float,3,3> S2_prime;                 
    svd(bestF,U2, S2, V2t);
    
    S2_prime.fill(0); S2_prime(0,0) = S2[0]; S2_prime(1,1) = S2[1];

    bestF = U2*S2_prime*V2t;

    //***--------------------- LAST STEP OF DE-NORMALIZATIOn --------------------------***

    N.fill(0.0f); N(0,0) = 0.001f; N(1,1) = 0.001f; N(2,2) = 1.0f;
    bestF = N*bestF*N;
    return bestF;
}

// Expects clicks in one image and show corresponding line in other image.
// Stop at right-click.
void displayEpipolar(Image<Color> I1, Image<Color> I2,
                     const FMatrix<float,3,3>& F) {

    cout << "click on a point in left or right image to display the associated epipolar line" << endl;
    cout << "right click when finished" << endl;

    float a;
    float b;
    while(true) 
    {
        int x,y;
        if(getMouse(x,y) == 3)
            break;
        int x1, y1, x2, y2;

        FVector<double,3> v;

        v[0] = x;
        v[1] = y;
        v[2] = 1;

        if (x<I1.width())
        {
            cout<<"Point from Image 1."<<endl;
            // ***--------------------- PROCESS EPIPOLAR LINE FOR IMAGE 2 -----------------------***
            v = transpose(F)*v; 
            a = -v[0]/v[1];
            b = -v[2]/v[1];
            x1 = 0;
            x2 = I2.width();

            y1 = a*x1 + b;
            y2 = a*x2 + b;
            x1 += I1.width();
            x2 += I1.width();

        }
        else if(x>I1.width())
        {
            cout<<"Point from Image 2."<<endl;
            // ***--------------------- PROCESS EPIPOLAR LINE FOR IMAGE 1 -----------------------***
            v[0] = x - I1.width();
            v = F*v;
            a = -v[0]/v[1];
            b = -v[2]/v[1];
            x1 = 0;
            x2 = I1.width()-1;

            y1 = a*x1 + b;
            y2 = a*x2 + b;
        }

        Color c(rand()%256,rand()%256,rand()%256);
        fillCircle(x, y, 2, c);
        drawLine(x1,y1,x2,y2,c);

    }
}

int main(int argc, char* argv[])
{
    srand((unsigned int)time(0));

    const char* s1 = argc>1? argv[1]: srcPath("im1.jpg");
    const char* s2 = argc>2? argv[2]: srcPath("im2.jpg");

    // Load and display images
    Image<Color,2> I1, I2;
    if( ! load(I1, s1) ||
        ! load(I2, s2) ) {
        cerr<< "Unable to load images" << endl;
        return 1;
    }
    int w = I1.width();
    openWindow(2*w, I1.height());
    display(I1,0,0);
    display(I2,w,0);
    cout<<"I1 :"<<I1.height()<<", "<<I1.width()<<endl;
    cout<<"I2 :"<<I2.height()<<", "<<I2.width()<<endl;
    vector<Match> matches;
    algoSIFT(I1, I2, matches);
    cout << " matches initial size : " << matches.size() << endl;
    click();
    
    FMatrix<float,3,3> F = computeF(matches);
    cout << "F="<< endl << F;
    cout << " new matches size : " << matches.size() << endl;

    // Redisplay with matches
    display(I1,0,0);
    display(I2,w,0);
    for(size_t i=0; i<matches.size(); i++) {
        Color c(rand()%256,rand()%256,rand()%256);
        fillCircle(matches[i].x1+0, matches[i].y1, 2, c);
        fillCircle(matches[i].x2+w, matches[i].y2, 2, c);        
    }
    click();

    // Redisplay without SIFT points
    display(I1,0,0);
    display(I2,w,0);
    displayEpipolar(I1, I2, F);

    endGraphics();
    return 0;
}
