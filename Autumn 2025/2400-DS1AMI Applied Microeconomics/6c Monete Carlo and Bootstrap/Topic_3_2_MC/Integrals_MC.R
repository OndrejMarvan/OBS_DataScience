############################ function 2D ################################

# Function which calculates the intergral using MC symulation
# f - f(x)
# a - the lower limit of integration.
# b - the upper limit of integration
# iter - number of itereations

mcint<-function(f, a, b, iter){
  l1<-b-a;					
  l2<-l1/1000;				
  x<-seq(a,b,by=l2);
  y<-matrix(NA,1001,2);			
  y[,1]<-x;					
  y[,2]<-f(x);				
  plot(y[,1],y[,2],pch=".", col="red");	
  lines(y[,1],y[,2],col="red");		
  s1<-0;
  s2<-0;
  ##### HERE ADJUSTMENT!!! ######
  sup1<-0; ### We have to set sup1 = 0 :) 
  ##### HERE ADJUSTMENT!!! ######
  sup2<-max(y[,2]);
  lines(c(a,a),c(sup1,sup2),col="black");
  lines(c(b,b),c(sup1,sup2),col="black");
  lines(c(a,b),c(sup2,sup2),col="black");
  lines(c(a,b),c(sup1,sup1),col="black");
  # 
  if(sup2==Inf) integral<-Inf;
  if(sup2!=Inf){
    for(i in 1:iter){
      m<-runif(1,a,b);
      n<-runif(1,sup1,sup2);
      r<-f(m);
      if(r>0){
        if(n>r | n<0)
        {
          s2<-s2+1;
          points(m,n,pch=".", col="black")
        };
        if(n<r & n>0){
          s1<-s1+1;
          points(m,n,pch=".", col="green")
        }
      };
      if(r<0){
        if(n<r | n>0){
          
          s2<-s2+1;
          points(m,n,pch=".", col="black")
        };
        if(n>r & n<0){
          s1<-s1-1;
          
          points(m,n,pch=".", col="green")	        }
      };
    };
    pole <-(b-a)*(sup2-sup1);
    procent<-s1/iter;
    # wartość całki
    integral<-procent*pole;
    print(integral)
    lines(y[,1],y[,2],col="red");
  };
  mcint<-integral
  lines(c(a,b),c(0,0),col="blue", lwd=3);
  return(mcint)
}


############################ function 2D ################################

# Function which calculates the intergral using MC symulation
# f - f(x,y)
# a - the lower and upper limits of integration for x 
# b - the lower and upper limits of integration for y

mcint2<-function(f, a, b, iter){		
  l1<-a[2]-a[1];		
  l2<-b[2]-b[1];			
  l3<-l1/100;			
  l4<-l2/100;			
  ## osi
  m<-seq(a[1],a[2],by=l3);	
  n<-seq(b[1],b[2],by=l4);	
  y<-matrix(NA,101,101);	
    for(i in 1:101){		
    for(j in 1:101){
      y[i,j]<-f(m[i],n[j])
    }
  };
  persp(m,n,y,col=terrain.colors(100),theta=40,phi=35); 
  sup1<-min(y);		
  sup2<-max(y);		
  s1<-0;			
  s2<-0;
  if(sup2==Inf) integral<-Inf;		
  if(sup1==(-Inf)) integral<-(-Inf);
  if(sup2!=Inf & sup1!=(-Inf)){	
    for(i in 1:iter){
      a1<-runif(1,a[1],a[2]);		
      a2<-runif(1,b[1],b[2]);		
      a3<-runif(1,sup1,sup2);		
      w<-f(a1,a2);				
      if(w>0){					
        if(a3<w & a3>0) s1<-s1+1;
        if(a3>w) s2<-s2+1;
        if(a3<w & a3<0) s2<-s2+1;
      };
      if(w<0){				
        if(a3<w) s2<-s2+1;
        if(a3>w & a3<0) s1<-s1-1;
        if(a3>w & a3>0) s2<-s2+1
      }
    };
    v<-sqrt((a[2]-a[1])^2)*sqrt((b[2]-b[1])^2)*sqrt((sup2-sup1)^2); 
   
    procent<-s1/iter;			
    
    integral<-procent*v;		
  };
  mcint2<-integral	}			


############## Example 1 #################
############## 2D ########################
  
funkcja3<-function(x) {(1/8)*x^3-(1/8)*x^2-1*x+2}	
integral_1 <- mcint(funkcja3,-1,5,100000)	
integral_1

############## Example 2 #################
############## 3D ########################

funkcja4<-function(x,y) {(1/8)*x^3-(1/8)*x^2-x+2+(1/8)*y^3-(1/8)*y^2-1*y}
a<-c(-2,3)		
b<-c(-2,3)			
integral_2  <- mcint2(funkcja4,a,b,10000)	
integral_2 