# 🙂 Clustering Segment Customer
<br>

**Tool** : Jupyter Notebook | [Link Notebook](https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Clustering%20%20segment%20customers.ipynb)<br>
**Programming Language** : Python <br>
**Libraries** : Pandas, NumPy, sklearn <br>
**Visualization** : Matplotlib, Seaborn<br>
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
 ### Case 1 : Not Outliers
 - Distribution plot of RFM (recency, frequency, monetary)

  <br>
 <p align="center">
    <kbd> <img width="600" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/rfm.png"> </kbd> <br>
 
</p>
<br>

 - Determine the optimal k value using the **Elbow Method**

 <br>
 <p align="center">
    <kbd> <img width="400" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/Elbow.png"> </kbd> <br>
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
    <kbd> <img width="400" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/Result_1.png"> </kbd> <br>
     
</p>
<br>
    In the graph, you can see that the frequency components seem to come from the same point, so we will create a table of the centroid values of each cluster for each component to be able to see the actual frequency value for each cluster different
   <br>
 <p align="center">
    <kbd> <img width="400" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/Result_2.png"> </kbd> <br>
     
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

### Case 2 : Outliers

- Result
   <br>
 <p align="center">
    <kbd> <img width="400" alt="distortion" src="https://github.com/quynhnguyenuet/Data-Analysis-Project/blob/main/Python_Analysis/Image/Result_case_2.png"> </kbd> <br>
     
</p>
<br>

* Group 0:

    Recency (Time since last transaction): Average about 308 days.

    Frequency (Transaction frequency): Average 2.15 times.

    Monetary (Transaction value): Average 330.89 currency units.

    Analysis: This group has high Recency, possibly a group of customers who have not made a purchase for a long time. However, they have high transaction frequency and value, may be a loyal customer group or have a special interest in your products/services.

* Group 1:

    Recency: Average about 488 days.

    Frequency: Average 1.59 times.

    Monetary: Average 89.61 currency units.

    Analysis: This group has high Recency and low transaction value, and may be a customer group that needs attention to stimulate repeat purchases.

* Group 2:

    Recency: Average about 95 days.

    Frequency: Average 1.90 times.

    Monetary: Average 757.27 currency units.

    Analysis: This group has low Recency and high transaction value, may be your loyal customer group or has special purchasing needs.

* Group 3:

    Recency: Average about 214 days.

    Frequency: Average 2.04 times.

    Monetary: Average 494.73 currency units.

    Analysis: This group has average Recency and high transaction frequency, can be a loyal or potential customer group.

* Group 4:

    Recency: Average about 393 days.

    Frequency: Average 2.02 times.

    Monetary: Average 202.90 currency units.

    Analysis: This group has high Recency and low transaction value, and may be a customer group that needs to be nurtured to stimulate repeat purchases.