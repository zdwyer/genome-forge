rule prepare_hisat2_splice_sites:
    input:
        lambda wc: '%s/%s/%s' % (config['genome_dir'], wc.build, ANNOTATIONS[wc.build])
    output:
        '%s/{build}/{index_dir}/splicesites.txt' % config['genome_dir']
    threads: 1
    conda:
        '%s/envs/hisat2.yaml' % (workflow.basedir)
    shell:
        'extract_splice_sites.py {input} > {output}'

rule prepare_hisat2_exons:
    input:
        lambda wc: '%s/%s/%s' % (config['genome_dir'], wc.build, ANNOTATIONS[wc.build])
    output:
        '%s/{build}/{index_dir}/exons.txt' % config['genome_dir']
    threads: 1
    conda:
        '%s/envs/hisat2.yaml' % (workflow.basedir)
    shell:
        'extract_exons.py {input} > {output}'

rule build_hisat2_index:
    input:
        genome = lambda wc: '%s/%s/%s' % (config['genome_dir'], wc.build, GENOMES[wc.build]),
        exon = lambda wc: '%s/%s/%s/exons.txt' % (config['genome_dir'], wc.build, wc.index_dir),
        ss = lambda wc: '%s/%s/%s/splicesites.txt' % (config['genome_dir'], wc.build, wc.index_dir)
    output:
        ['%s/{build}/{index_dir}/{index_name}.%s.ht2' % (config['genome_dir'], i) for i in range(1, 9)]
    params:
        index_prefix = lambda wc: '%s/%s/%s/%s' % (config['genome_dir'], wc.build, wc.index_dir, wc.index_name)
    conda:
        '%s/envs/hisat2.yaml' % (workflow.basedir)
    threads: 8
    shell:
        'hisat2-build -q -p {threads} --ss {input.ss} --exon {input.exon} {input.genome} {params.index_prefix}'