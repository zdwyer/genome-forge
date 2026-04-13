rule build_bowtie2_index:
    input:
        genome = lambda wc: '%s/%s/%s' % (config['genome_dir'], wc.build, GENOMES[wc.build])
    output:
        ['%s/{build}/{index_dir}/{index_name}.%s.bt2' % (config['genome_dir'], i) for i in ['1', '2', '3', '4', 'rev.1', 'rev.2']]
    params:
        index_prefix = lambda wc: '%s/%s/%s/%s' % (config['genome_dir'], wc.build, wc.index_dir, wc.index_name)
    conda:
        '%s/envs/bowtie2.yaml' % (workflow.basedir)
    threads: 4
    resources:
        mem_mb = 16000
    shell:
        'bowtie2-build --quiet --threads {threads} {input.genome} {params.index_prefix}'