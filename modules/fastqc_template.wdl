version 1.0

workflow FastqcWF {
	input {
		Array[File] fastqs
		File? limits
	}

	call fastqc {
		input:
			fastqs = fastqs,
			limits = limits
	}

	output {
		Array[File] reports = fastqc.reports
	}

	meta {
		author: "Ash O'Farrell"
	}
}

task fastqc {
	input {
		Array[File] fastqs
		File? limits
		Int addldisk = 10
		Int cpu = 4
		Int memory = 8
		Int preempt = 1 
	}
	Int finalDiskSize = addldisk + ceil(size(fastqs, "GB"))

	command <<<
		mkdir outputs
		if [[ "~{limits}" != "" ]]
		then
			fastqc -o outputs -l ~{limits} ~{sep=" " fastqs}
		else
			fastqc -o outputs ~{sep=" " fastqs}
		fi
	>>>

	runtime {
		cpu: cpu
		docker: "biocontainers/fastqc:v0.11.9_cv8"
		disks: "local-disk " + finalDiskSize + " SSD"
		memory: "${memory} GB"
		preemptible: "${preempt}"
	}

	output {
		Array[File] reports = glob("outputs/*.html")
	}
	
}
