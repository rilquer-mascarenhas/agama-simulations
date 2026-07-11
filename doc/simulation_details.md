## Simulation details

Simulations will be run in two parts. First, we will simulate individuals across space forward in time utilizing [SLiM](). From these simulations, we will retrieve simulated genealogies, for each scenarios, which reflect dispersal and ecological patterns (e.g., male-biased dispersal will yield spatially restricted mitochondrial genealogies, but widely spread nuclear genealogies). Note that these genealogies do not coalesce into one single ancestor, since they only represent the recent history of population and begin with several individuals occupying space. The goal of SLiM is to record the effect of ecology/space on the shape of genealogy.

Genealogies retrieved from SLiM will then be transfered to [msprime](), a coalescent simulator, which will be responsible for 1) coalescing individuals in theses genealogies into one single common ancestral variant, creating a

This entire process is known as *recapitation*. It basically consists of focusing SLiM on simulating only the aspects of populations that classic backward coalescent simulations can't (i.e., nonWF spatial populations with complex ecologies). Additional details on the concepts and steps behind recapitationn can be found in the [SLiM manual](https://benhaller.com/slim/SLiM_Manual.pdf) and in [Haller et al., 2018](https://doi.org/10.1111/1755-0998.12968).

#### Simulations in SLiM

Models in SLiM will be non Wright-Fisher (nonWF) and spatially explicit. Two types of genomic components will be simulated in SLiM: mitochondrial DNA (mtDNa) and nuclear DNA (nuDNA). The mtDNA will exhibit no recombination, while nuDNA will have some possibility of recombination within the marker, given by a recombination rate. The length and recombination rates will be set to match empirical values observed for *Agama* lizards. Additionally, mtDNA will be simulated as haploid component and maternally inheritted, while nuDNA will be diploid and inherited by both parents. This difference between marker inheritance will be set within the `reproduction()` callback.

**Spatial settings**

Models will be initialized with individuals uniformly assigned to the species range. In all scenarios, topography plays a role in restricting individual movement, i.e., individuals move easier through areas with similar altitudes (modeled using altitude as a resistance layer in SLiM) and areas below a certain altitude threshold (i.e., valleys) are disproportionately harder to move through. These settings combine to simulate populations adapted to high altitude areas, where valleys form a barrier to dispersal, mimicking species behavior. Mating probability is controled by spatial proximity (i.e., closer individuals have a higher chance of mating), so a general IBD signal will emerge in all models. The presence of topography will additionally mimick the genetic structure observed in the empirical data, which will inherently lead to some genetic structure in all scenarios. This guarantees that our scenarios are focusing on testing not what drives mtDNA structure, but what drives mito-nuclear discordance (which is the main ecological question of this paper).

**Population ecology**

Carrying capacity is controlled by spatial interactions dictating individual fitness: individuals in overcrowded areas will exhibit less fitness, mimicking lack of resources, while individuals in sparse areas will have higher fitness. This contributes to keep population size steady across the entire range. Individual longevity is set to 7 years (i.e., individuals can reproduce 7 times before being removed from the population). Sex ratio will be kept at 50%. At the end of the reproductive event, both offspring and adult individuals will disperse across space, with dispersal distance drawn from a pre-defined normal distribution.

**Modeling scenarios**

*Scenario 1* (geography only) will consist of a model where dispersal is influenced solely by topography IBR: as mentioned above, a resistance layer based on altitude will be implemented, and areas below a certain value will be inaccessible. Some movement across valleys to different highlands will be allowed, as this may eventually happen (but it shouldn't be common given what is known about the species biology).

> Simpler alternative: implement a shapefile of highlands as a binary raster (highland vs valley), instead of a continuous altitude raster. This would remove the need to calculate resistance-based movement, possibly making the script simpler and faster.

*Scenario 2* (geography + climatic IBR) will build on scenario 1 and add environmental suitability from the species's climatic niche. Environmental suitability will affect individual fitness (alongside intrinsinc fitness due to age and spatial competition with nearby individual).

> *Scenario 2* may be a lot of extra work without a lot of extra reward. If individuals are mostly restricted to highlands and are associated to rocky formations, it might be the case that there won't be a lot of variation in climatic suitability through the highlands. Adding climate may just make this model slightly better than geography. Not having a lot of difference between scenarios 1 and 2 may actually make it harder for our model-selection approach to differentiate between the two, and artificially inflate accuracy values for other models. In addition, it naturally leads to the question of why suitability is kept constant across time. Our argument is that cliamte variation across the Pleistocene (and older) wouldn't be that important, since this species is associated to these rocky formations and the overall topography has not changed significantly throughout the past. In a way, this is also an argument to not use species's climatic niche at all. This would make our hypothesis test simpler: can we explain what we observe with space only (scenario 1) or do we need to invoke some ecological/adaptive explanation (scenarios 3 and 4)?

The motivation for scenarios 1 and 2 is to see whether the observed mito-nuclear discordance can arise solely from space structuring individuals in combination with some inheret properties of nuDNA. In other words, if our data is best explained by scenarios 1 and/or 2, it suggests that space is structuring mtDNA, and even tho it may structure nuDNA to some extent (will depend on simulation results), nuDNA does not exhibit structure primarily due to slower mutation rates, the presence of recombination and overall larger N<sub>E</sub>.

Scenarios 3 and 4 then explore two possible hypotheses for the observe mito-nuclear divergence: 1) divergence is kept due to female phylopatry

*Scenario 3* (geography + male-biased dispersal) decreases mean dispersal values for females, in orderdifferent mean dispersal values for males and females, allowing males to disperse more while females would be more phylopatric, leading to higher spatial differentiation in mtDNA genealogies than in nuDNA genealogies.

> For this scenario to reproduce lack of structure in nuDNA, some dispersal across valleys and exchange of males among highlands needs to occur.

*Scenario 4* (selection on mtDNA lineages) will be modeled by assigning each individual to a mtDNA lineage in the beginning of the simulation, based on their spatial location. The fitness of each lineage will be determined by its original location: fitness will be higher if individuals are within the original boundaries for its lineage than when they are outside those original boundaries. This mimics individuals in each lineage being selected positively at each of the different highlands. Male and female dispersal are kept equal and similar to the values in scenarios 1 and 2, making it possible for individuals to move across valleys to different highlands. Under strong selection, those individuals would have low fitness, leading to divergence across the mtDNA. In this model, for selection to occur only in mtDNA and not nuDNA, you would need high dispersal values for males with some probability of male survival and reproduction in a different highland.

> Conceptually, scenario 3 is asking: is geography pushing for differentiation but male-biased dispersal is mixing up nuDNA? Scenario 4 is asking: is geography **NOT** the factor structuring genetic differentiation, but instead **selection** is simply pushing towards mtDNA differentiation where, otherwise, it would simply observe complete admixture (even with the existing topography)?

> The way we are simulating things here (i.e., using SLiM + recapitation), it gets a little harder to distinguish between scenarios 3 and 4. For a scenario of mito-nuclear differentiation arising from selection on mtDNA, males would still need to be dispersing more than females (i.e., nuDNA is still admixed due to this male dispersal). This makes this scenario similar to scenario 3; the only difference is that in scenario 3 mtDNA divergence arises from drift while in scenario 4 it arises from selection. Selection is usually stronger than drift, meaning we could differentiate both by how long it took for the divergence to occur. In some cases, drift can be equally or more strong than selection in driving differentiation (mostly in cases where Ne is very low and µ is very high). We could try to tease those two apart, for sure, but the point is that to capture that difference we might need to fully simulate selection on SLiM (i.e., ditching `msprime`).

**Duration and recording**
How long? 100k generations maybe?

#### Simulations in `msprime`

- Ne will be scaled to match empirical values. nuDNA Ne is four times that of mtDNA ne.
- Mutation and recombination rates will follow traditional rates for mtDNA and nuclear DNA.
- All rates will be [scaled by generation time](https://tskit.dev/pyslim/docs/latest/time_units.html), in order to convert from SLiM genealogies in nonWF to `msprime` genealogies in WF.

**Summary statistics**
- Pi per lineage
- Pi over space
- Fst across major lineages
- Pairwise Dxy across localities/major lineages
- Site Frequency Spectrum of each lineage
- Pairwise joint SFS?
