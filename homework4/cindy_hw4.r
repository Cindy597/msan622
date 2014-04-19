
require(tm)        # corpus
require(SnowballC) # stemming
require(ggplot2)
require(wordcloud)

data_source <- DirSource(
    # indicate directory
    directory = file.path("mydataset"),
    encoding = "UTF-8",     # encoding
    pattern = "*.txt",      # filename pattern    
    recursive = FALSE,      # visit subdirectories?
    ignore.case = FALSE)    # ignore case in pattern?

my_corpus <- Corpus(
    data_source, 
    readerControl = list(
        reader = readPlain, # read as plain text
        language = "en"))   # language is english

my_corpus <- tm_map(my_corpus, tolower)

my_corpus <- tm_map(
    my_corpus, 
    removePunctuation,
    preserve_intra_word_dashes = TRUE)

my_corpus <- tm_map(
    my_corpus, 
    removeWords, 
    stopwords("english"))

# getStemLanguages()
my_corpus <- tm_map(
    my_corpus, 
    stemDocument,
    lang = "porter") # try porter or english

my_corpus <- tm_map(
    my_corpus, 
    stripWhitespace)

# Remove specific words
my_corpus <- tm_map(
    my_corpus, 
    removeWords, 
    c("will", "can", "get", "that", "year", "let","said","now","new","never","must",
      "much","made","make","little","like","just","know","great","good","first","even",
      "come","came","back","done","dont","enough","find","give","howev","men","put",
      "see","seem","shall","still","take","think","thought","tell","want","went","time",
      "well","two","thing","right","place","peopl","man","look","long","littl","leav",
      "part","old","work","mai","answer","and"))

# Calculate Frequencies
my_tdm <- TermDocumentMatrix(my_corpus)

# Convert to term/frequency format
my_tdm$dimnames$Docs <- c("Leather","Glass","Wool","Silk","Porcelain")
my_matrix <- as.matrix(my_tdm)
my_df <- data.frame(
    word = rownames(my_matrix), 
    # necessary to call rowSums if have more than 1 document
    freq = rowSums(my_matrix),
    stringsAsFactors = FALSE) 

# Sort by frequency
my_df <- my_df[with(
    my_df, 
    order(freq, decreasing = TRUE)), ]
# Do not need the row names anymore
rownames(my_df) <- NULL




#Visulization 1: bar plot

bar_df <- data.frame(
  Silk = my_matrix[, "Silk"],
  Wool = my_matrix[, "Wool"],
  Glass=my_matrix[,"Glass"],
  Leather=my_matrix[,"Leather"],
  Porcelain=my_matrix[,"Porcelain"],  
  stringsAsFactors = FALSE)
rownames(bar_df) <- rownames(my_matrix)
#order by decreasing
bar_df <- bar_df[order(
  rowSums(bar_df), 
  decreasing = TRUE),]
#remove rows in which there is 0 value
row_sub<-apply(bar_df,1,function(row) all(row >5))
bar_df<-bar_df[row_sub,]
#just look at top 10 frequency words
bar_df <- head(bar_df, 10)

words<-rownames(bar_df)
index<-as.data.frame(c(rep(colnames(bar_df)[1],length(bar_df$Leather)),
                       rep(colnames(bar_df)[2],length(bar_df$Glass)),
                       rep(colnames(bar_df)[3],length(bar_df$Wool)),
                       rep(colnames(bar_df)[4],length(bar_df$Silk)),
                       rep(colnames(bar_df)[5],length(bar_df$Porcelain))))
freq<-as.data.frame(c(bar_df$Leather,bar_df$Glass,bar_df$Wool,bar_df$Silk,bar_df$Porcelain))
word<-as.data.frame(rep(words,5))
bar_df<-cbind(index,freq,word)
colnames(bar_df)<-c("type","freq","word")

# Print a bar plot of the top 10 words by different material types
p1 <- ggplot(bar_df, aes(x = type,y = freq,fill=word)) +
  geom_bar(stat = "identity") +
  ggtitle("Story of different materials based on top 10 frequency words") +
  xlab("Material Type") +
  ylab("Total Word Frequency") +
  theme_minimal() +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid = element_blank()) +
  theme(axis.ticks = element_blank())
print(p1)



#Visulization 2: heatmap
new_df<-as.data.frame(my_matrix)
#sort the dataframe by each coloumn (increasing)
heatmap_df<-new_df[order(new_df$Glass,new_df$Silk,new_df$Leather,new_df$Wool,new_df$Porcelain),]
#invert the data frame (decreasing)
heatmap_df<-heatmap_df[nrow(heatmap_df):1,]
#select words whose sum frequency in those five files are greater than 30 
mynew<-heatmap_df[apply(heatmap_df,1,sum)>150,]
words<-rownames(mynew)
index<-as.data.frame(c(rep(colnames(mynew)[1],length(mynew$Leather)),
                       rep(colnames(mynew)[2],length(mynew$Glass)),
                       rep(colnames(mynew)[3],length(mynew$Wool)),
                       rep(colnames(mynew)[4],length(mynew$Silk)),
                       rep(colnames(mynew)[5],length(mynew$Porcelain))))
freq<-as.data.frame(c(mynew$Leather,mynew$Glass,mynew$Wool,mynew$Silk,mynew$Porcelain))
word<-as.data.frame(rep(words,5))
heatmap_df<-cbind(index,freq,word)
colnames(heatmap_df)<-c("type","freq","word")

p <- ggplot(heatmap_df, aes(x = type, y = word))
p <- p + geom_tile(aes(fill = freq), colour = "white")
p <- p + theme_minimal()
# remove axis titles, and grid
#change the size of plot title
#keep tick marks
p<-p+ggtitle("Word Frequency of Historical Story for Five Materials")
p <- p + theme(axis.title = element_blank())
p <- p + theme(plot.title=element_text(size=20))
p <- p + theme(panel.grid = element_blank())
# remove legend (since data is scaled anyway)
p <- p + theme(legend.position = "none")
# remove padding around grey plot area
p <- p + scale_x_discrete(expand = c(0, 0))
p <- p + scale_y_discrete(expand = c(0, 0))    
# get diverging color scale from colorbrewer
#green, blank, blank, purple, purple
palette <- c("#008837", "#f7f7f7", "#f7f7f7", "#7b3294","#7b3294")
#p <- p + scale_fill_gradient(colours=palette)
#use a 5 color gradient (with a swath of white in the middle)
p <- p + scale_fill_gradientn(colours = palette)
print(p)


# Visulization 3: wordcloud
wordcloud(
  my_df$word,
  my_df$freq,
  scale = c(4,0.5),      # size of words
  min.freq = 5,          # drop infrequent
  max.words = 50,         # max words in plot
  random.order = FALSE,   # plot by frequency
  rot.per = 0.3,          # percent rotated
  # set colors
  #colors = brewer.pal(9, "GnBu"),
  colors = brewer.pal(12, "Paired"),
  # color random or by frequency
  random.color = TRUE,
  # use r or c++ layout
  use.r.layout = FALSE
  #vfont=c("sans serif","plain")
)

comparison.cloud(my_matrix,random.order=FALSE,
                 colors=c("#00B2FF","red","#FF0099","#6600CC","green"),
                 title.size=1.5,max.words=200)

