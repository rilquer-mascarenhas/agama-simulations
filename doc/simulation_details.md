## Simulation details

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

**Modeling framework**

Overall approach: SLIM and recapitation

- SLIM for ecology
	- Two types of chromosomes, mtDNA and nuclear, simulated in SLIM with no genetics and tree sequence recording.
	- One non-recombining genealogy for mtDNA. Nuclear DNA will have a recombination rate and possibility of recombination within the marker.
	- mtDNA is haploid and maternally inherited, while nuclear DNA is diploid and inherited by both parents
	- Male-base dispersal
	- How long? 100k generations maybe?
	- For model 4 (modeling selection): Each individual will be assigned to a mtDNA lineage in the beginning of the simulation, based on their spatial location. Each lineage will have a different fitness across space, based on latitude and longitude values. This mimics individuals in each lineage being selected positively at each of the different highlands. Divergence is maintained in the simulation by this selection (if individuals move across, they die, so genealogies don't cross.)
- `msprime` for recapitation
	- Scaling Ne to match empirical values
	- Nuclear Ne is four times that of mtDNA Ne.
	- Mutation rate (µ) will follow traditional rates for mtDNA and nuclear DNA.
	- Both Ne and µ need to be [scaled by generation time](https://tskit.dev/pyslim/docs/latest/time_units.html) (to convert from SLiM nonWF to `msprime` WF)

**Summary statistics**
- Pi per lineage
- Pi over space
- Fst across major lineages
- Pairwise Dxy across localities/major lineages
- Site Frequency Spectrum of each lineage
	- Maybe also joint pairwise SFS?
