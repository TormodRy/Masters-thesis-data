#################
# single variable
#################

library(quantmod)

# Set start and end date dates
start_date <- as.Date('1990-01-01')
end_date <- as.Date('2020-01-01')


# Set relevant variables here
# Some of these are 404. Check for updates FRED names


# Fetch data for the specified indicators
getSymbols('AAA', src = 'FRED', from = start_date, to = end_date)



####################
# Multiple variables
####################


# library(quantmod)

# Set start and end date dates
start_date <- as.Date('1990-01-01')
end_date <- as.Date('2020-01-01')


# Set relevant variables here
# Some of these are 404. Check for updates FRED names
StockWatsonV <- c( 
  "RPI",        
  "W875RX1",    
  "INDPRO",     
  "IPFPNSS",    
  "IPFINAL",    
  "IPCONGD",    
  "IPDCONGD",    
  "IPNCONGD",    
  "IPBUSEQ",    
  "IPMAT",      
  "IPDMAT",     
  "IPNMAT",     
  "IPMANSICS",  
  "IPB51222s",  
  "IPFUELS",    
  "CUMFNS",     
  "HWI",        
  "HWIURATIO",  
  "CLF16OV",    
  "CE16OV",     
  "UNRATE",     
  "UEMPMEAN",   
  "UEMPLT5",    
  "UEMP5TO14",  
  "UEMP15OV",   
  "UEMP15T26",  
  "UEMP27OV",   
  "CLAIMSx",    
  "PAYEMS",     
  "USGOOD",     
  "CES1021000001", 
  "USCONS",     
  "MANEMP",     
  "DMANEMP",    
  "NDMANEMP",   
  "SRVPRD",     
  "USTPU",      
  "USWTRADE",   
  "USTRADE",    
  "USFIRE",     
  "USGOVT",     
  "CES0600000007", 
  "AWOTMAN",    
  "AWHMAN",     
  "CES0600000008", 
  "CES2000000008", 
  "CES3000000008", 
  "HOUST",      
  "HOUSTNE",    
  "HOUSTMW",    
  "HOUSTS",     
  "HOUSTW",     
  "PERMIT",     
  "PERMITNE",   
  "PERMITMW",   
  "PERMITS",    
  "PERMITW",    
  "DPCERA3M086SBEA", 
  "CMRMTSPLx",  
  "RETAILx",   
  "ACOGNO",     
  "AMDMNOx",    
  "ANDENOx",    
  "AMDMUOx",    
  "BUSINVx",    
  "ISRATIOx",   
  "UMCSENTx",  
  "M1SL",      
  "M2SL",      
  "M2REAL",    
  "BOGMBASE",  
  "TOTRESSNS", 
  "NONBORRES", 
  "BUSLOANS",  
  "REALLN",    
  "NONREVSL",  
  "CONSPI",    
  "MZMSL",     
  "DTCOLNVHFNM", 
  "DTCTHFNM",  
  "INVEST",    
  "FEDFUNDS",  
  "CP3Mx",     
  "TB3MS",     
  "TB6MS",     
  "GS1",       
  "GS5",       
  "GS10",      
  "AAA",       
  "BAA",
  'CPIAUCSL'
)

# This can be useful with multiple variables,
# but not necessary for one variables
# Filter out empty elements from the vector
StockWatsonV <- StockWatsonV[!sapply(StockWatsonV, function(x) length(x) == 0)]

# Fetch data for the specified indicators
getSymbols(StockWatsonV, src = 'FRED', from = start_date, to = end_date)


# Filter out the symbols that were not successfully imported
StockWatsonV_success <- StockWatsonV[sapply(StockWatsonV, exists)]

# Combine data into a single dataframe
combined_data <- do.call(merge, lapply(StockWatsonV_success, function(sym) get(sym)))

combined_data[data_diff]


# View the first few rows of the combined dataframe
head(combined_data)
print(combined_data)
count.observations(combined_data)

dim(combined_data)

save(file = combined_data)
saveRDS(combined_data, file = 'filepath')

#########
# csv
#########
# I didnt find the path to fetch. You would have to download from the page
# and then load it in like this
# Link: https://research.stlouisfed.org/econ/mccracken/fred-databases/
cur_dat <- read.csv(file = 'C:/Users/tormo/OneDrive/Skole/Masteroppgave/Coding and data/current.csv')
head(cur_dat)
colnames(cur_dat)
ncol(cur_dat)
