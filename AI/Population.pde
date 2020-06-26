class Population {
   
   assasin[] assasins;
   assasin bestassasin;
   
   int bestassasinScore = 0;
   int gen = 0;
   int samebest = 0;
   
   float bestFitness = 0;
   float fitnessSum = 0;
   
   Population(int size) {
      assasins = new assasin[size]; 
      for(int i = 0; i < assasins.length; i++) {
         assasins[i] = new assasin(); 
      }
      bestassasin = assasins[0].clone();
      bestassasin.replay = true;
   }
   
   boolean done() {  //check if all the assasins in the population are dead
      for(int i = 0; i < assasins.length; i++) {
         if(!assasins[i].dead)
           return false;
      }
      if(!bestassasin.dead) {
         return false; 
      }
      return true;
   }
   
   void update() {  //update all the assasins in the generation
      if(!bestassasin.dead) {  //if the best assasin is not dead update it, this assasin is a replay of the best from the past generation
         bestassasin.look();
         bestassasin.think();
         bestassasin.move();
      }
      for(int i = 0; i < assasins.length; i++) {
        if(!assasins[i].dead) {
           assasins[i].look();
           assasins[i].think();
           assasins[i].move(); 
        }
      }
   }
   
   void show() {  //show either the best assasin or all the assasins
      if(replayBest) {
        bestassasin.show();
        bestassasin.brain.show(0,0,360,790,bestassasin.vision, bestassasin.decision);  //show the brain of the best assasin
      } else {
         for(int i = 0; i < assasins.length; i++) {
            assasins[i].show(); 
         }
      }
   }
   
   void setBestassasin() {  //set the best assasin of the generation
       float max = 0;
       int maxIndex = 0;
       for(int i = 0; i < assasins.length; i++) {
          if(assasins[i].fitness > max) {
             max = assasins[i].fitness;
             maxIndex = i;
          }
       }
       if(max > bestFitness) {
         bestFitness = max;
         bestassasin = assasins[maxIndex].cloneForReplay();
         bestassasinScore = assasins[maxIndex].score;
         //samebest = 0;
         //mutationRate = defaultMutation;
       } else {
         bestassasin = bestassasin.cloneForReplay(); 
         /*
         samebest++;
         if(samebest > 2) {  //if the best assasin has remained the same for more than 3 generations, raise the mutation rate
            mutationRate *= 2;
            samebest = 0;
         }*/
       }
   }
   
   assasin selectParent() {  //selects a random number in range of the fitnesssum and if a assasin falls in that range then select it
      float rand = random(fitnessSum);
      float summation = 0;
      for(int i = 0; i < assasins.length; i++) {
         summation += assasins[i].fitness;
         if(summation > rand) {
           return assasins[i];
         }
      }
      return assasins[0];
   }
   
   void naturalSelection() {
      assasin[] newassasins = new assasin[assasins.length];
      
      setBestassasin();
      calculateFitnessSum();
      
      newassasins[0] = bestassasin.clone();  //add the best assasin of the prior generation into the new generation
      for(int i = 1; i < assasins.length; i++) {
         assasin child = selectParent().crossover(selectParent());
         child.mutate();
         newassasins[i] = child;
      }
      assasins = newassasins.clone();
      evolution.add(bestassasinScore);
      gen+=1;
   }
   
   void mutate() {
       for(int i = 1; i < assasins.length; i++) {  //start from 1 as to not override the best assasin placed in index 0
          assasins[i].mutate(); 
       }
   }
   
   void calculateFitness() {  //calculate the fitnesses for each assasin
      for(int i = 0; i < assasins.length; i++) {
         assasins[i].calculateFitness(); 
      }
   }
   
   void calculateFitnessSum() {  //calculate the sum of all the assasins fitnesses
       fitnessSum = 0;
       for(int i = 0; i < assasins.length; i++) {
         fitnessSum += assasins[i].fitness; 
      }
   }
}
