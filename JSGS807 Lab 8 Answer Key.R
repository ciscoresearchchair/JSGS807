#Following the tutorial at 
#  http://htmlpreview.github.io/?https://github.com/andrewpbray/oiLabs-base-R/blob/master/probability/probability.html

#The goals for this lab are to 
#(1) think about the effects of independent and dependent events, 
#(2) learn how to simulate shooting streaks in R, and 
#(3) to compare a simulation to actual data in order to determine 
#  if the hot hand phenomenon appears to be real.

#Getting Started
#This tutorial will focus on the performance of one player: 
#  Kobe Bryant of the Los Angeles Lakers. 
#In his performance in the 2009 NBA finals, many spectators commented on 
#  how he appeared to show a "hot hand". 
#First, load some data from those games
download.file("http://www.openintro.org/stat/data/kobe.RData", destfile = "kobe.RData")
#this next command not only loads the data from kobe.RData, but also 
#  loads the calc_streak function in the Environment pane of RStudio
load("kobe.RData")
#then look at the first several rows
#In this data frame, every row records a shot taken by Kobe Bryant. 
#If he hit the shot (made a basket), a hit, H, is recorded in the column 
#  named  basket, otherwise a miss, M, is recorded.
head(kobe)

#Just looking at the string of hits and misses, it can be difficult to gauge 
# whether or not it seems like Kobe was shooting with a hot hand. 
#One way we can approach this is by considering the belief that hot hand shooters 
# tend to go on shooting streaks. 
#In this lab, we define the length of a shooting streak to be the number of consecutive
# baskets made until a miss occurs.
#For example, in Game 1 Kobe had the following sequence of hits and misses 
# from his nine shot attempts in the first quarter:
#  H M | M | H H M | M | M | M
#To verify this use the following command:
kobe$basket[1:9]

#Exercise 1
#Qu: What does a streak length of 1 mean, 
#  i.e. how many hits and misses are in a streak of 1? 
#Ans: The tutorial defines the length of a shooting streak to be the number of 
#  consecutive baskets made until a miss occurs. A streak length of 1 means a hit 
#  followed by a miss.
#Qu: What about a streak length of 0? 
#Ans: A streak length of 0 would be a miss followed by a miss. 

#A custom function calc_streak was loaded in with the data.
#You can find it in the Environment pane in RStudio
#This function can be used to calculate the lengths of all shooting streaks.

kobe_streak <- calc_streak(kobe$basket)

#This command show Kobe's streak data in a table
table(kobe_streak)

#We then make a bar plot from a table of the streak data. 
#A bar plot is preferable here since our variable is 
#  discrete – counts – instead of continuous.
#Enter the following command and a bar plot will appear in the Plots pane in RStudio
barplot(table(kobe_streak))

#Exercise 2
#Qu: Describe the distribution of Kobe’s streak lengths from the 2009 NBA finals. 
#Ans: He had 24 1-hit streaks, 6 each of 2 and 3-hit streaks, and 1 4-hit streaks.
#Qu: What was his typical streak length? How long was his longest streak of baskets?
#Ans: Most "streaks" were of misses (39). Alternatively, he had 24 1-hit streaks.
#  (depending on how you define a "streak")


#Simulations in R
#Compare Kobe's streak lengths to someone without hot hands: an independent shooter.
#While we don’t have any data from a shooter we know to have independent shots, 
#  that sort of data is very easy to simulate in R. 
#In a simulation, you set the ground rules of a random process and 
#  then the computer uses random numbers 
#  to generate an outcome that adheres to those rules. 
#As a simple example, you can simulate flipping a fair coin with the following.
outcomes <- c("heads", "tails")
#The vector outcomes can be thought of as a hat with two slips of paper in it: 
#  one slip says heads and the other says tails. 
sample(outcomes, size = 1, replace = TRUE)
#The function  sample draws one slip from the hat and 
#  tells us if it was a head or a tail.

#If you wanted to simulate flipping a fair coin 100 times, 
#  you could either run the function 100 times or, 
#  more simply, adjust the size argument, 
#  which governs how many samples to draw (the replace = TRUE argument indicates 
#  we put the slip of paper back in the hat before drawing again). 
#Save the resulting vector of heads and tails in a new object called sim_fair_coin.
sim_fair_coin <- sample(outcomes, size = 100, replace = TRUE)

#To view the results of this simulation, type the name of the object 
sim_fair_coin

#and then use table to count up the number of heads and tails.
table(sim_fair_coin)

#Since there are only two elements in outcomes, 
#  the probability that we “flip” a coin 
#  and it lands heads is 0.5. Say we’re trying to 
#  simulate an unfair coin 
#  that we know only lands heads 20% of the time. We can adjust for this 
#  by adding an argument 
#  called prob, which provides a vector of two probability weights
sim_unfair_coin <- sample(outcomes, size = 100, replace = TRUE, prob = c(0.2, 0.8))
#  prob=c(0.2, 0.8) indicates that for the two elements in the outcomes vector, 
#  we want to select the first one, heads, 
#  with probability 0.2 and the second one, tails 
#  with probability 0.8. 

#Exercise 3
#Qu: In your simulation of flipping the unfair coin 100 times, 
#  how many flips came up heads?
#Ans: Enter the following commands
sim_unfair_coin
table(sim_unfair_coin)

#Simulating the Independent Shooter
#Simulating a basketball player who has independent shots 
#  uses the same mechanism 
#  that we use to simulate a coin flip. 
#  To simulate a single shot from an independent shooter 
#  with a shooting percentage of 50% we enter:
outcomes <- c("H", "M")
sim_basket <- sample(outcomes, size = 1, replace = TRUE)

#If you wanted to simulate an independent shooter shooting 100 times, 
#  adjust the size argument, and save the resulting vector 
#  in a new object called sim_basket
sim_basket <- sample(outcomes, size = 100, replace = TRUE)
table(sim_basket)

#To make a valid comparison between Kobe and our simulated independent shooter, 
#  we need to align both their shooting percentage and the number of attempted shots.

#Exercise 4
#Qu: What change needs to be made to the sample function 
#  so that it reflects 
#  a shooting percentage of 45%? Make this adjustment, 
#  then run a simulation to sample 133 shots. 
#  Assign the output of this simulation to the object called sim_basket.
sim_basket <- sample(outcomes, size = 133, replace = TRUE, prob = c(0.45, 0.55))
table(sim_basket)
#Note that we’ve named the new vector sim_basket, the same name that 
#  we gave to the previous vector 
#  reflecting a shooting percentage of 50%. In this situation, 
#  R overwrites the old object 
#  with the new one, so always make sure that you don’t need the information 
#  in an old vector 
#  before reassigning its name.
#With the results of the simulation saved as sim_basket, we have the data necessary 
#  to compare Kobe to our independent shooter. 

#  We can look at Kobe’s actual data alongside our simulated data.
table(kobe$basket)
table(sim_basket)
#Both data sets represent the results of 133 shot attempts, 
#  each with the same shooting percentage of 45%. 
#  We know that our simulated data is from a shooter that has independent shots 
#  (we progammed it that way). 
#  That is, we know the simulated shooter does not have a hot hand.

#ON YOUR OWN: Comparing Kobe Bryant to the Independent Shooter
#Using calc_streak, compute the streak lengths of sim_basket.
sim_streak <- calc_streak(sim_basket)
#View the sim_streak data
table(sim_streak)
#Then draw a bar plot of that simulated streak data
barplot(table(sim_streak))

#Qu 1: Describe the distribution of streak lengths. 
#Ans:  0  1  2  3  4 
#     49 13  8  5  3 (this will be different for any particular simulation)
#Qu: What is the typical streak length for this simulated independent shooter 
#  with a 45% shooting percentage? 
#Ans: one basket (13 times) (this will be different every time)
#How long is the player’s longest streak of baskets in 133 shots?
#Ans: 4 baskets (3 times) (again, this will be different for everyone)

#Qu 2: If you were to run the simulation of the independent shooter 
# a second time, how would you expect its streak distribution to compare 
#  to the distribution from the question above? Exactly the same? 
#  Somewhat similar? Totally different? Explain your reasoning.
#Ans: re-run the sim_basket simulation:
sim_basket <- sample(outcomes, size = 133, replace = TRUE, prob = c(0.45, 0.55))
table(sim_basket)
sim_streak <- calc_streak(sim_basket)
table(sim_streak)
barplot(table(sim_streak))
#Ans: The distribution will be similar (most "streaks" will be misses), 
#  but different (streak lengths, and frequency). 

#Qu 3: How does Kobe Bryant’s distribution of streak lengths 
#  compare to the distribution of streak lengths for the simulated shooter? 
#Ans: generally similar shape to the distributions
#  Using this comparison, do you have evidence that the hot hand model 
#  fits Kobe’s shooting patterns? Explain.
kobe_streak <- calc_streak(kobe$basket)
table(kobe_streak)
barplot(table(kobe_streak))
#Ans: no, Kobe's data matches the simulated independent (non hot-hand) shooter.

