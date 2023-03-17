/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gl.project;

import java.util.ArrayList;

/**
 *
 * @author moubarak
 */
public class Abonne extends Client{
    public static Abonne reverse(String s1,String s2){for(int i=0;i<Abonne.abonnes.size();i++){if(Abonne.abonnes.get(i).getID().equals(s1) && Abonne.abonnes.get(i).getMDP().equals(s2))return Abonne.abonnes.get(i);
    }
        return null;
        
    
    }
    
    
    private String id,nom,prenom,num;
    private String mdp;
    private double balance=0;
    public static double meilleurConso;
    public static ArrayList<Abonne> abonnes=new ArrayList<Abonne>();
    public static String[] abonnesS;
    public static int nbrAbo=0;
    
    public Abonne(String nom,String prenom,String num,String mdp){this.nbrAbo+=1;this.nom=nom;this.prenom=prenom;this.num=num;this.mdp=mdp;Abonne.abonnes.add(this);this.Maj();this.id=this.nom+this.prenom;}
    public void setNom(String nom){this.nom=nom;}
    public void setPrenom(String prenom){this.prenom=prenom;}
    public void setNum(String num){this.num=num;}    
    public void Maj(){Abonne.abonnesS=new String[nbrAbo+1];
    for(int i=0;i<abonnes.size();i++)
    {abonnesS[i]=abonnes.get(i).toString();}
    }
    public String getID(){return this.id;}
    public String getMDP(){return this.mdp;}
    public String getNom(){return this.nom;}
    public String getPrenom(){return this.prenom;}
    public String getNum(){return this.num;}
    public double getBalance(){return this.balance;}
    @Override
    public String toString(){return this.nom+" "+this.prenom+" "+this.balance+"$";}
    
    public void acheter(double a){this.balance=this.balance+a;this.Maj();
   if(this.balance>meilleurConso){meilleurConso=this.balance;MeilleurConso m=new MeilleurConso();m.setVisible(true);}
   }
    }

    
    
