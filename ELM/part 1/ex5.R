library('mlbench')
source('treinaELM.R')

bidimensionalNormals <- mlbench::mlbench.2dnormals(200)
xor <- mlbench::mlbench.xor(100)
circle <- mlbench::mlbench.circle(100)
spirals <- mlbench::mlbench.spirals(100, sd = 0.05)

biClasses <- as.numeric(bidimensionalNormals$classes)
biClasses <- biClasses - 1

xorClasses <- as.numeric(xor$classes)
xorClasses <- xorClasses - 1

circleClasses <- as.numeric(circle$classes)
circleClasses <- circleClasses - 1

spiralsClasses <- as.numeric(spirals$classes)
spiralsClasses <- spiralsClasses - 1

nNeuronios <- c(5, 10, 30)

for(i in nNeuronios) {
  
  plotContourAndDots(bidimensionalNormals$x, biClasses, i)
  
  plotContourAndDots(xor$x, xorClasses, i)
  
  plotContourAndDots(circle$x, circleClasses, i)
  
  plotContourAndDots(spirals$x, spiralsClasses, i)
}