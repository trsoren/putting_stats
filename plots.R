library(dplyr)

df = read.csv('data.csv')

#plot daily putting rate
num_made = df$dagger + df$luna + df$caltrop
daily_rate = c()
for (i in seq(1, nrow(df), 10)){
    tot_putts_made = 0.0
    for (j in 0:9){
        tot_putts_made = tot_putts_made + num_made[i+j]
    }
    daily_rate = c(daily_rate, tot_putts_made / 30.0)
}
out = 'Daily_Rate.pdf'
if (file.exists(out)) {file.remove(out)}
pdf(file=out, width=7, height=5, onefile=FALSE)
plot.new()
barplot(daily_rate, 
    main='Daily rate of putts made from 25ft',
    xlab='Days',
    ylab='Rate (%)',
    ylim=c(0,.7))
abline(h=c(0,.1,.2,.3,.4,.5,.6,.7), col='black', lty=1, lwd=1)
barplot(daily_rate, 
    add=TRUE,
    names.arg=c(1:length(daily_rate)),
    col='deepskyblue')
dev.off()

#plot confidence intervals for each putters proportion of makes
dagger.test = prop.test(sum(df$dagger), nrow(df), conf.level=0.95)
caltrop.test = prop.test(sum(df$caltrop), nrow(df), conf.level=0.95)
luna.test = prop.test(sum(df$luna), nrow(df), conf.level=0.95)
out = 'Putter_Rate.pdf'
if (file.exists(out)) {file.remove(out)}
pdf(file=out, width=5, height=5, onefile=FALSE)
plot.new()
plot(c(1:3), c(dagger.test$estimate, caltrop.test$estimate, luna.test$estimate),
    ylim=c(0.2,0.7),
    xlim=c(0.5,3.5),
    xaxt='n',
    main='95% confidence interval for the \nproportion of putts made from 25ft',
    ylab='% of putts made',
    xlab='Putter',
    pch=15)
axis(1, at=c(1,2,3), labels=c('Dagger', 'Caltrop', 'Luna'))
arrows(1, dagger.test$conf.int[1], 1, dagger.test$conf.int[2], length=0.1, angle=90, code=3)
arrows(2, caltrop.test$conf.int[1], 2, caltrop.test$conf.int[2], length=0.1, angle=90, code=3)
arrows(3, luna.test$conf.int[1], 3, luna.test$conf.int[2], length=0.1, angle=90, code=3)
dev.off()

#2 proportion Z test to see if Dagger differs from Luna
test = prop.test(x=c(sum(df$dagger),sum(df$luna)), n=c(nrow(df),nrow(df)))
print(test)

#plot confidence intervals for proportion of makes based on order
df1 = data.frame(matrix(ncol=3, nrow=nrow(df)))
for (i in 1:nrow(df)){
    for (j in 1:3){
        if (substr(df$order[i], j, j) == 'C'){
            df1[i,j] = df$caltrop[i]
        }
        if (substr(df$order[i], j, j) == 'D'){
            df1[i,j] = df$dagger[i]
        }
        if (substr(df$order[i], j, j) == 'L'){
            df1[i,j] = df$luna[i]
        }
    }
} 
first.test = prop.test(sum(df1[1]), nrow(df1), conf.level=0.95)
second.test = prop.test(sum(df1[2]), nrow(df1), conf.level=0.95)
third.test = prop.test(sum(df1[3]), nrow(df1), conf.level=0.95)
out = 'Order_Rate.pdf'
if (file.exists(out)) {file.remove(out)}
pdf(file=out, width=5, height=5, onefile=FALSE)
plot.new()
plot(c(1:3), c(first.test$estimate, second.test$estimate, third.test$estimate),
    ylim=c(0.2,0.7),
    xlim=c(0.5,3.5),
    xaxt='n',
    main='95% confidence interval for the \nproportion of putts made from 25ft',
    ylab='% of putts made',
    xlab='Order putt was thrown',
    pch=15)
axis(1, at=c(1,2,3), labels=c('1st', '2nd', '3rd'))
arrows(1, first.test$conf.int[1], 1, first.test$conf.int[2], length=0.1, angle=90, code=3)
arrows(2, second.test$conf.int[1], 2, second.test$conf.int[2], length=0.1, angle=90, code=3)
arrows(3, third.test$conf.int[1], 3, third.test$conf.int[2], length=0.1, angle=90, code=3)
dev.off()

