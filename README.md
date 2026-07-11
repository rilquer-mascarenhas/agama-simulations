# Spatial simulations of *Agama boulengeri*

This is a repo summarizing the approach and storing the scripts utilized for testing different hypotheses regarding observed mito-nuclear discordance in *Agama boulengeri*.

### Scenarios:
**(aka: what are the hypotheses we are trying to test with [SLiM](https://github.com/messerlab/slim)?)**

We have four scenarios that basically test the relative impact of the landscape, abiotic environment and two alternative explanations for mito-nuclear discordance: male-biased dispersal and mitochondrial lineage selection.

**Scenario 1: Geography only:**
- Can we observe mito-nuclear discordance from the effect of geography alone? Geography here means the effect of topography in restricting individual movement and gene flow (i.e., topographic Isolation-by-Resistance). This is something of a null model, to test whether geography is enough to lead to observed patterns.

**Scenario 2: Geography + climatic IBR**
- Is the observed pattern explained by a combination of the effects of topography and climatic suitability (as dictated by the species's climatic niche)?

**Scenario 3: Geography + Male-biased dispersal**
- Male individuals of *A. boulengeri* tend to disperse more than females; this behavior could potentially drive the maintenance of mtDNA divergence (i.e., females lineages don't spread spatially) while keeping the nuclear genome admixed through male dispersal.

**Scenario 4: Geography + disruptive selection on mitochondrial lineages**
- Selective pressures may act on the three separate mitochondrial lineages to keep them differentiated. In this scenario, both male and female individuals move freely through the environment (constrained by topography) but individuals from a lineage have lower fitness when located outside the original range of that lineage.

Additional details on the hypotheses rationale, the simulation mechanics and the model-testing approach can be found [here (in progress)](doc/simulation_details.md).
