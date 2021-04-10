x<-1:4; 
y=x*x
z = 5:8
# Example 1
line(x, y, axes = FALSE)
axis(side=1, at = 1:4, labels=LETTERS[1:4])
axis(2)
# Example 2
plot(x, y, axes = FALSE)
axis(side=1, at=1:4, labels=LETTERS[1:4])
axis(2)
box() #- To make it look like "usual" plot


glimpse(tes)


plot(tes$tanggal, tes$edi, pch=18, col="red", type="b",
     frame=FALSE, xaxt="n") # Remove x axis

plot(tes$tanggal, tes$ep, pch=18, col="green") # Remove x axis
