rule download_genome:
    output:
        temp('%s/{build}/{genome}.gz' % config['genome_dir'])
    params:
        lambda wc: GENOME_URLS[wc.build]
    resources:
        concur_download = 1
    threads: 1
    shell:
        'curl {params} --create-dirs --silent --output {output}'

rule unzip_genome:
    input:
        '%s/{build}/{genome}.gz' % config['genome_dir']
    output:
        '%s/{build}/{genome}' % config['genome_dir']
    threads: 1
    shell:
        'gunzip -c {input} > {output}'

rule download_annotation:
    output:
        temp('%s/{build}/{annotation}.gz' % config['genome_dir'])
    params:
        lambda wc: ANNOTATION_URLS[wc.build]
    resources:
        concur_download = 1
    threads: 1
    shell:
        'curl {params} --create-dirs --silent --output {output}'

rule unzip_annotation:
    input:
        '%s/{build}/{annotation}.gz' % config['genome_dir']
    output:
        '%s/{build}/{annotation}' % config['genome_dir']
    threads: 1
    shell:
        'gunzip -c {input} > {output}'