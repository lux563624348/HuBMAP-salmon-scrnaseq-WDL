version 1.1

task RunSalmonRNAseq {
    input {
        File fastq_1
        File fastq_2
        String species
        String run_id
        String protocol
        Int expected_cells
        Int cpu
        String memory
        String email
    }

    command {
        mkdir /RUN
        
        dockerd > dockerd.log 2>&1 &
        
        # Wait for dockerd to be ready
        while ! docker info >/dev/null 2>&1; do
            sleep 1
        done

        bash /DATA/Run_scRNA.sh \
            ~{fastq_1} ~{fastq_2} ~{species} ~{run_id} ~{protocol} ~{expected_cells} ~{cpu} ~{memory} ~{email}
    }

    runtime {
        docker: "lux563624348/scrnaseq_did:beta"
        cpu: cpu
        memory: memory 
        privileged: true
    }

    output {
        Array[File] pipeline_output = glob("*.html")
        #File pipeline_output = "output/result.txt" # Adjust based on your pipeline output
    }
}

workflow RunscRNAseq {
    input {
        File fastq_1
        File fastq_2
        String species
        String run_id
        String protocol
        Int expected_cells
        Int cpu
        String memory
        String email
    }

    call RunSalmonRNAseq {
        input:
            fastq_1=fastq_1,
            fastq_2=fastq_2,
            species=species,
            run_id=run_id,
            protocol=protocol,
            expected_cells=expected_cells,
            cpu=cpu,
            memory=memory,
            email=email
    }

    output {
        Array[File] pipeline_output = RunSalmonRNAseq.pipeline_output
    }
}