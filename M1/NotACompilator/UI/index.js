var exec = require('child_process').exec;
function shell(command, callback){
    exec(command, function(error, stdout, stderr){ callback(stdout+error); });
};

document.addEventListener("DOMContentLoaded", function(event) {
    var fs=require('fs');
    var instances = M.AutoInit();
    var contents = fs.readFileSync('COMP/entree.txt', 'utf8');
    var alg=document.getElementById("alg");    
    alg.innerHTML=contents;

    
    var contents = fs.readFileSync('COMP/Lexique.l', 'utf8');
    var alg=document.getElementById("lex");    
    alg.innerHTML=contents;

        
    var contents = fs.readFileSync('COMP/Syntaxe.y', 'utf8');
    var alg=document.getElementById("synt");    
    alg.innerHTML=contents;

    var save=document.getElementById("save");
    save.onclick=function(){
        var alg=document.getElementById("alg"); 
        console.log("contenu : "+alg.value);
        fs.writeFile("COMP/entree.txt", String(alg.value) ,function(err) {
            if(err) {
                return console.log(err);
            }
        
            console.log("Algorithme sauvegardé ! ;)");
        }); 

        var synt=document.getElementById("synt"); 
        fs.writeFile("COMP/Syntaxe.y", String(synt.value) ,function(err) {
            if(err) {
                return console.log(err);
            }
        
            console.log("Syntaxique sauvegardé ! ;)");
        }); 

        var lex=document.getElementById("lex"); 
        fs.writeFile("COMP/Lexique.l", String(lex.value) ,function(err) {
            if(err) {
                return console.log(err);
            }
        
            console.log("Lexical sauvegardé ! ;)");
        }); 
    };

    var compile=document.getElementById("compile");
    compile.onclick=function(){
            console.log("Compiling.");
         shell("cd COMP && flex Lexique.l && bison -d Syntaxe.y && gcc lex.yy.c Syntaxe.tab.c -lfl -ly -o analyseur && cd ..",function(output){
            var result=document.getElementById("result");
            result.innerHTML=result.innerHTML+'<br/>==>'+output;
         });
    };

    var execute=document.getElementById("execute");
    execute.onclick=function(){
        console.log("Executing.");
     shell("cd COMP && flex Lexique.l && bison -d Syntaxe.y && gcc lex.yy.c Syntaxe.tab.c -lfl -ly -o analyseur && ./analyseur<<entree.txt && cd ..",function(output){
        var result=document.getElementById("result");
        result.innerHTML=result.innerHTML+'<br/>==>'+output;
     });
    };

    
    
  });


