---
output:
  html_document:
    css: styles.css
---

## About this Application

This R Shiny web application presents the work of the Ocean Health Index (OHI), a collaborative effort made possible through contributions from more than 65 scientists/ocean experts and partnerships between organizations including the National Center for Ecological Analysis and Synthesis, Sea Around Us, Conservation International, National Geographic, and the New England Aquarium.  

All the data in this app can be found at the [OHI webpage](http://ohi-science.org/data/)  

Code for this webapp can be found in [this Github repository](https://github.com/richpauloo/ohi).

***


## Appendix

*5 year change* values are calculated by fitting a linear model to the data, grouped by **goal, dimension, and region**. The value is therefore, the slope of the best fit line through the metric across 2012 - 2017. Generally speaking, positive values (blue) are associated with an improvement in score, and negative values (red) are associated with a reduction in score.  


## Description of Dimensions  


* **score**: Final OHI score that takes into account current status and predicted future status  
* **status**: Current status of goal based on current state relative to reference state  
* **future**: Predicted future status (based on contributions of pressures, resilience, and trend)  
* **pressures**: Cumulative pressures acting on a goal to reduce scores, used to calculate future status  
* **resilience**: Average resilience variables acting on a goal to increase scores, used to calculate future status  
* **trend**: Predicted proportional change in status after five years, based on average change in status per year multiplied by five, used to estimate future status  



