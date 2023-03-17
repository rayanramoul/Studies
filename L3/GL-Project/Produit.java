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
public class Produit {
    public static Produit reverse(String s){for(int i=0;i<Produit.produits.size();i++){if(Produit.produits.get(i).toString().equals(s)){return Produit.produits.get(i);}
    }
        return null;
        
    
    }

    private int prix;
    private int numero;
    private String nom;
    public static ArrayList<Produit> produits= new ArrayList<Produit>();
    public static ArrayList<String> noms=new ArrayList<String>();
    public int nbrProd=0;
    public static String[] nomsS;

    
    public Produit(String nom,int numero,int prix){this.nbrProd+=1;this.nom=nom;this.numero=numero;this.prix=prix;Produit.produits.add(this);Produit.noms.add(nom);this.Maj();}
    public void Maj(){Produit.nomsS=new String[produits.size()];
    for(int i=0;i<produits.size();i++)
    {nomsS[i]=Produit.produits.get(i).toString();}
    }
    

    
    public void setPrix(int prix){this.prix=prix;}
    public void setNUmero(int prix){this.prix=prix;}
    public void setNom(String nom){this.nom=nom;}
    
    public String toString(){
      String test=new String();
      test=this.nom+"("+this.numero+")";
      
              return test;}
    public String getNom(){return this.nom;}
    public int getPrix(){return this.prix;}
    public int getNumero(){return this.numero;}
}