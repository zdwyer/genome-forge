# Genome Forge

A systematic approach to managing genomes and building alignment indexes using snakemake.

## Installation

### Requirements

-   Python 3.8+
-   Required Python packages:
    - `snakemake`
    - `conda`

### Usage

#### Set up configuration file

Create the configuration yaml at `config/config.yaml`. 

The config must include the following:

```yaml
genome_dir: '' # absolute path to where you want to store your genomes
genome_registry: '' # absolute path to your registry of genomes
```

Example `config.yaml`:

```yaml
genome_dir: '/Users/<username>/genomes' 
genome_registry: '/Users/<username>/genomes/genome_registry.yaml' 
```

**Note:** There is an empty template for the config file at config/config_template.yaml. You can use this template with:

```bash
cp config/config_template.yaml config/config.yaml
```

#### Set up the genome registry

You must create a genome registry at the location you specified in the config file.

For each genome / annotation you wish to track, add an entry to the genome registry. Each must contain the following information (see below for additional information that can be provided):

```yaml
<build_identifier>:
  species:
  genome:
  annotation:
```

You can specify which indexs you want by adding additional information:

```yaml
<build_identifier>:
  species:
  genome:
  annotation:
  <alignment index 1>
  <alignment index 2>
```

Here is an example to track yeast genome which needs both a hisat2 and bowtie2 alignment index:

```yaml
yeast_ensembl_v115:
  species: 'yeast'
  genome: 'Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa'
  annotation: 'Saccharomyces_cerevisiae.R64-1-1.115.gtf'
  hisat2_index:
    directory: 'hisat2_index'
    prefix: 'index'
  bowtie2_index:
    directory: 'bowtie2_index'
    prefix: 'index'
```

This example will create the following file structure at the `genome_dir` defined in `config/config.yaml`:

```bash
.
├── genome_registry.yaml
└── yeast
    └── yeast_ensembl_v115
        ├── bowtie2_index
        │   ├── index.1.bt2
        │   ├── index.2.bt2
        │   ├── index.3.bt2
        │   ├── index.4.bt2
        │   ├── index.rev.1.bt2
        │   └── index.rev.2.bt2
        ├── hisat2_index
        │   ├── exons.txt
        │   ├── index.1.ht2
        │   ├── index.2.ht2
        │   ├── index.3.ht2
        │   ├── index.4.ht2
        │   ├── index.5.ht2
        │   ├── index.6.ht2
        │   ├── index.7.ht2
        │   ├── index.8.ht2
        │   └── splicesites.txt
        ├── Saccharomyces_cerevisiae.R64-1-1.115.gtf
        └── Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa
```

### Build Alignment Indexes

```bash
snakemake --configfile config/config.yaml --use-conda --cores <number of cores>
```