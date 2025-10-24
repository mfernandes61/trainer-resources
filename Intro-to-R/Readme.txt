Files to help teach the new Intro to R course

R Graph gallery https://r-graph-gallery.com/
Joins animation https://www.garrickadenbuie.com/project/tidyexplain/

NB In chapter 14 when you load patchwork you may get this error (or similar)
library(patchwork)
# Error: package or namespace load failed for ‘patchwork’:
# object ‘is_ggplot’ is not exported by 'namespace:ggplot2'

If this happens then install.packages("tidyverse") to get the latest tidyverse/ggplot2
and then library(tidyverse) and library(patchwork). The section should now work - seems to be a version issue in patchwork...
