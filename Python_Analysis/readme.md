# 🙂 Clustering Segment Customer
<br>

**Tool** : Jupyter Notebook | [Link Notebook](https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Clustering%20%20segment%20customers.ipynb)<br>
**Programming Language** : Python <br>
**Libraries** : Pandas, NumPy, sklearn <br>
**Visualization** : Matplotlib, Seaborn, yellow-brick <br>
**Source Dataset** :[Data Source](https://github.com/quynhnguyenuet/Data-Analysis-Project/tree/main/Data) <br>
<br>
<br>

## 📂 **Data Modeling with K-Means Clustering**
### Pre-processing
- Prepare Dataset 
- Calculate RFM metrics from available customer data
- After preparing the data set, we proceed to remove outliers for the clustering process. By applying **isolation forest** . This is because the isolation forest identifies outliers in a multivariate manner, so I feel this method is more suitable for identifying outliers.
<br>
<p align="center">
    <kbd> <img width="600" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/Number%20Outlier%20and%20Non%20-%20Outlier.png"> </kbd> <br>
     Outlier and Non-Outlier Data by Isolation Forest
</p>
<br>
- Because the number of outliers is quite large, outliers are analyzed separately.

 ### Data Annalysis
 * Case 1 : Not Outliers
 - Distribution plot of RFM (recency, frequency, monetary)

  <br>
 <p align="center">
    <kbd> <img width="600" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/rfm.png"> </kbd> <br>
     Elbow curve
</p>
<br>
 - Determine the optimal k value using the **Elbow Method**
 <br>
 <p align="center">
    <kbd> <img width="300" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/Elbow.png"> </kbd> <br>
     Elbow curve
</p>
<br>

 - It can be seen that the optimal k value with the **Elbow method** is 4 or 5
 - Determine the optimal k value using **Silhouette Score**
    - For n_clusters = 4 The average silhouette_score is : 0.5808088367367596
    - For n_clusters = 5 The average silhouette_score is : 0.5671484370034111

 - Result with k = 4
  <br>
 <p align="center">
    <kbd> <img width="300" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/Result_1.png"> </kbd> <br>
     
</p>
<br>
    In the graph, you can see that the frequency components seem to come from the same point, so we will create a table of the centroid values of each cluster for each component to be able to see the actual frequency value for each cluster different
   <br>
 <p align="center">
    <kbd> <img width="300" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/Result_2.png"> </kbd> <br>
     
</p>
<br>

 * Group 0:
        Recency: The average Recency of this group is about 228 days, meaning they made a purchase about 228 days ago.
        Frequency: On average they have only 1.04 transactions.
        Monetary: The average transaction value of this group is 122.88 currency units.
        Analysis: This group has higher Recency compared to other groups, which may imply that they do not buy frequently and may be a group that needs to be stimulated to buy again.
* Group 1:
        Recency: The average Recency of this group is 48.87 days, only lower than group 0.
        Frequency: This group has a Frequency index of 1.0, which may imply that they do not purchase frequently.
        Monetary: The average transaction value of this group is 174.20 currency units, higher than group 0.
        Analysis: This group has low Recency and high transaction value, can be a group of potential customers or loyal customers.
* Group 2:
        Recency: The average Recency of this group is the highest, about 330.31 days.
        Frequency: Similar to group 1, this group has a Frequency index of 1.0.
        Monetary: The average transaction value of this group is the lowest, only 65.91 currency units.
        Analysis: This group has high Recency and low transaction value, and may be a group that needs attention to increase transaction frequency and value.
* Group 3:
        Recency: The average Recency of this group is about 145.37 days.
        Frequency: This group has the highest Frequency index among the groups, with an average of 1.06 transactions.
        Monetary: The average value of this group's transactions is 167.79 currency units.
        Analysis: This group has average Recency, but has the highest transaction frequency and relatively high transaction value, which can be a group of potential customers or loyal customers.
