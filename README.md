# Understanding the Platform Economy: <br> Signals, Trust, and Social Interaction

Code and data accompanying the paper 'Understanding the Platform Economy: Signals, Trust, and Social Interaction' (**https://scholarspace.manoa.hawaii.edu/bitstream/10125/64373/0508.pdf**). 

## Description
**Last modified:** May 2020 <br>
**Authors:** Maik Hesse, Fabian Braesemann, David Dann, Timm Teubner <br>
**Licence:** CC-BY (4.0)

**Abstract:** Two-sided markets are gaining increasing importance. Examples include accommodation and car sharing, resale, shared mobility, crowd work, and many more. As these businesses rely on transactions among users, central aspects to virtually all platforms are the creation and maintenance of trust. While research has considered effects of trust-building on diverse platforms in isolation, the overall platform landscape has received much less attention. However, cross-platform comparison is important since platforms vary in their degree of social interaction, which, as we demonstrate in this paper, determines the adequacy and use of different trust mechanisms. Based on actual market data, we examine the mechanisms platforms employ and how frequent users rely on them. We contrast this view against survey data on users’ perceptions of the context-specific importance of these trust-building tools. Our findings provide robust evidence for our reasoning on the relation between platforms’ degree of social interaction and the associated expressive trust cues. <br>


## Folder Structure and Disclaimer
Since some data has been crawled with the help of commercial tools, neither all data nor all code to reproduce the entire work is included. The provided code allows crawling textual components from web pages, analysing sentiment and tagging the following keywords:

<br> <br> 

```
.
+-- code
|   +-- Crawling
    |   +-- 1_Crawler.ipynb (code for crawling web pages)
    |   +-- 2_CleanUpEdges.ipynb (cleaning the crawled network data)
    +-- Analysis
    |   +-- 3_ContentAnalysis.ipynb (code for analysing web page content after cleaned up)
    |   +-- 4_NetworkAnalysisPlots.ipynb (visualizing and analysing networks)
    |   +-- 5_AutomotiveFigures.R (code for reproducing figures)
+-- data
|   +-- car_sales.csv (data of global car sales)
|   +-- node_data.csv (tagged web page data including the features "sentiment", "digital trend"...)
+-- readme.md
```

## Reference
Please cite as follows 

```
@article{
hesse2020understanding,
title={Understanding the Platform Economy: Signals, Trust, and Social Interaction},
author={Maik Hesse, Fabian Braesemann, David Dann, and Timm Teubner},
booktitle={HICSS 2020 Proceedings},
year={2020},
pages = {1-10},
url={https://scholarspace.manoa.hawaii.edu/bitstream/10125/64373/0508.pdf},
}
```

