# Visualizing my daily commute

## Introduction and Methods
I love data visualization, and one holiday my partner surprised me with the book [_Dear Data_](http://www.dear-data.com/). The book is a series of weekly letters two data analysts wrote to one another with visualizations of data on random topics like the number of times they said "thank you" or the number of times they looked at a clock. Some friends and I decided to take a stab at it ourselves: for three weeks, we collected data about transportation and travel.

I decided to quantify my walks to work. I used the [GPS Logger for Android](https://play.google.com/store/apps/details?id=com.mendhak.gpslogger&hl=en) app to get 1 Hz time series data for 44 commutes. Data collection began the moment I left my apartment building or work, and ended when I touched the door handle of my destination.

## Results and Discussion
### The commute
![](https://i.imgur.com/yksKuZ9.png)

Above, the GPS coordinates for my walks are overlain on a Google Maps image of my commute. There exists substantial noise in the GPS data (I wasn't actually passing in and out of buildings on the walk... _or was I??_), but overall the data show a clear trend of walking down my home street, turning onto a busy street, and stopping at my coworking space. _[Just because this is the internet, I've removed all identifying info from the figures and text.]_

Another way to visualize this is to use a perspective plot. Here, the heights correspond to the amount of data collected at that particular location.

![](https://i.imgur.com/4Wcx8pV.png)

### Commute times and speeds
Below, the histogram on the left shows the distribution of commute durations, with the color corresponding to my mood at how long my commute took. ;-) The histogram on the right shows the GPS Logger's speed recordings. According to these data, I spent approximately 21% of my commute waiting for a street light to change, most likely to cross the major street.

![](https://i.imgur.com/3cwjKCi.png)

### Combining the commute and speed data
Were there certain regions of my commute where I tended to move more slowly? The data are too noisy to get a nice answer for this question, but if we squint at the plot below, we can see a bit of a trend at the intersections of the major street and a side street, when I generally tended to wait. The GPS data were binned by location and the bins are colored by average speed.

![](https://i.imgur.com/p6W3ndr.png)


## The code
All R code to produce the above plots is included in this repository. I'm happy to provide further clarification if anyone would like.

Cheers,
Matt
