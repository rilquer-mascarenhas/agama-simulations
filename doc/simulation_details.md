## Simulation details

Simulations will be run in two parts. First, we will simulate individuals across space forward in time utilizing [SLiM](). From these simulations, we will retrieve simulated genealogies, for each scenarios, which reflect dispersal and ecological patterns (e.g., male-biased dispersal will yield spatially restricted mitochondrial genealogies, but widely spread nuclear genealogies). Note that these genealogies do not coalesce into one single ancestor, since they only represent the recent history of population and begin with several individuals occupying space. The goal of SLiM is to record the effect of ecology/space on the shape of genealogy.

Genealogies retrieved from SLiM will then be transfered to [msprime](), a coalescent simulator, which will be responsible for 1) coalescing individuals in theses genealogies into one single common ancestral variant, creating a

This entire process is known as *recapitation*. It basically consists of focusing SLiM on simulating only the aspects of populations that classic backward coalescent simulations can't (i.e., nonWF spatial populations with complex ecologies). Additional details on the concepts and steps behind recapitationn can be found in the [SLiM manual](https://benhaller.com/slim/SLiM_Manual.pdf) and in [Haller et al., 2018](https://doi.org/10.1111/1755-0998.12968).

#### Simulations in SLiM

Models in SLiM will be non Wright-Fisher (nonWF) and spatially explicit. Two types of genomic components will be simulated in SLiM: mitochondrial DNA (mtDNa) and nuclear DNA (nuDNA). The mtDNA will exhibit no recombination, while nuDNA will have some possibility of recombination within the marker, given by a recombination rate. The length and recombination rates will be set to match empirical values observed for *Agama* lizards. Additionally, mtDNA will be simulated as haploid component and maternally inheritted, while nuDNA will be diploid and inherited by both parents. This difference between marker inheritance will be set within the `reproduction()` callback.

**Spatial settings**
Models will be initialized with individuals uniformly assigned to the species range. In all scenarios, topography plays a role in restricting individual movement, i.e., individuals move easier through areas with similar altitudes (modeled using altitude as a resistance layer in SLiM) and areas below a certain altitude threshold (i.e., valleys) are disproportionately harder to move through. These settings combine to simulate populations adapted to high altitude areas, where valleys form a barrier to dispersal, mimicking species behavior and the genetic structure observed. Having models

Mating probability is controled by spatial proximity (i.e., closer individuals have a higher chance of mating), therefore a general IBD signal will emerge in all models. At the end of the reproductive event, both offspring and adult individuals will disperse across space, with dispersal distance drawn from a pre-defined normal distribution.

**Population ecology**
Carrying capacity is controlled by spatial interactions dictating individual fitness: individuals in overcrowded areas will exhibit less fitness, mimicking lack of resources, while individuals in sparse areas will have higher fitness. This contributes to keep population size steady across the entire range. Individual longevity is set to 7 years (i.e., individuals can reproduce 7 times before being removed from the population). Sex ratio will be kept at 50%.

**Modeling scenarios**
*Scenario 1* (geography only) will consist of a model where dispersal is influenced solely by topography IBR: as mentioned above, a resistance layer based on altitude will be implemented, and areas below a certain value will be inaccessible. Dispersal will be set as to avoid a large number of individuals on the edge of highland areas jumping to neighbouring highland across valleys (this may eventually happen, but it shouldn't be common given what is known about the species biology).
> Simpler alternative: implement a shapefile of highlands as a binary raster (highland vs valley), instead of a continuous altitude raster. This would remove the need to calculate resistance-based movement, possibly making the script simpler and faster.

*Scenario 2* (geography + )

The motivation for scenarios 1 and 2 is to see whether this mito-nuclear discordance can arise solely from space structuring individuals, combined with inheret properties of nuDNA. If our data is best explained by scenarios 1 and/or 2, it suggests that space is structuring mtDNA, and it may structure nuclear, but just nuclear being slow, or having a bigger Ne is enough to create the mit-nuc discordance

> *Scenario 2* may be a lot of extra work without a lot of extra reward.



Scenario 1, then 2, then 3, then 4
Modeling geography only
Modeling geography/topography and climatic IBR (just add the SDMs)

Modeling male-biased dispersal

Modeling selection
For model 4 (modeling selection): Each individual will be assigned to a mtDNA lineage in the beginning of the simulation, based on their spatial location. Each lineage will have a different fitness across space, based on latitude and longitude values. This mimics individuals in each lineage being selected positively at each of the different highlands. Divergence is maintained in the simulation by this selection (if individuals move across, they die, so genealogies don't cross.)

**Duration and recording**
How long? 100k generations maybe?

#### Simulations in SLiM


Recapitation in msprime
- Scaling Ne to match empirical values
	- Nuclear Ne is four times that of mtDNA Ne.
	- Mutation rate (µ) will follow traditional rates for mtDNA and nuclear DNA.
	- Both Ne and µ need to be [scaled by generation time](https://tskit.dev/pyslim/docs/latest/time_units.html) (to convert from SLiM nonWF to `msprime` WF)

Summary statistics
- Pi per lineage
- Pi over space
- Fst across major lineages
- Pairwise Dxy across localities/major lineages
- Site Frequency Spectrum of each lineage
	- Maybe also joint pairwise SFS?
