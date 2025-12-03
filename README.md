# 🦋 Team 9: Modelling _Lymantria dispar dispar_ populations from defoliation data 

## Description
_Lymantria dispar dispar_, known commonly as the spongy moth, is an invasive species found throughout eastern North America and causes widespread defoliation on the order of thousands of hectares of host trees. This project takes in defoliation data collected in the province of Ontario over fifty years of outbreaks and, using three different models, predicts the corresponding moth population. To evaluate these models, defoliation data is then derived from population. Models each output graphical visualizations of data and the model. A full evaluation of the limitations and evolution of each model, as well as background on the context, can be found in the Report. This project was submitted as a term project for MAT292: Ordinary Differential Equations at the University of Toronto, and was jointly authored by Alice Gao, Richa Shah, Serena Suleman, and Cindy Yu.

## Dependencies
Required MATLAB Toolboxes:
- **Optimization Toolbox** - for ```lsqnonlin``` and ```fmincon```
- **Statistics and Machine Learning Toolbox** - for some utility functions
- **MATLAB Base Package** - for ODE solvers ```ode45``` and plotting

**Note**: Install of these packages is **not** required when using MATLAB online, only when local. 

## File Structure
```
-Team-9-Spongy-Moth-Code/
├── model 1/		
│   ├── inverse_cost_function.m       
│   ├── main.m            
│   └── moth_foliage_ode.m           
├── model 2/	
│   ├── fit_Residuals.m          
│   ├── main.m            
│   └── moth_foliage_ode.m 
├── model 3/
│   ├── fit_Residuals.m         
│   ├── lotka_volterra_ode.m 
│   ├── main.m            
│   └── run_model.m 
├── original_defoliation_data.csv          	
├── README.md              
└── report.pdf	
```

## How to Run
Once dependencies are installed (if required), each model can be downloaded independently (i.e., one folder at a time). Then, running the ```main.m``` file found in each model will produce graphical representations of predicted moth population and defoliation data. 

## Expected Outputs
- **Model 1**: One figure, depicting actual defoliation data, predicted moth population data, and the corresponding derived defoliation data, between 1980 and 2023. 
- **Model 2**: One figure, depicting actual and predicted defoliation, as well as predicted moth population from 1986-1993 (corresponding to a single outbreak). 
- **Model 3**: One figure depicting actual defoliation data, predicted moth population data, and the corresponding derived defoliation data, between 1980 and 2023; and a second figure depicting the same data for four individual outbreaks within that time frame.

## Issues/Limitations
Models 1 and 2 have difficulty fitting to the largest outbreak (i.e., the 2018-2022 outbreak), resulting in essentially neglecting that outbreak altogether.
Model 3 is a simple derived L-V model, which was unable to fit the data as a whole. Each outbreak was fitted independently instead. 

## Acknowledgements
Data obtained for this project generally come from [this report](https://www.ontario.ca/files/2024-05/mnrf-srb-forest-health-conditions-report-2023-2024-05-09.pdf). The authors of this report would like to acknowledge Seo Jeonghyeok from Geospatial Ontario and Gillian Muir from Forestry Ontario, who kindly responded to our emails and provided invaluable context.
