#!/usr/bin/env nextflow

process GC_Filter {
input:
path expData
val cutoff

output:
path "output.txt"

script:
"""
#!/usr/bin/env python3
from Bio import SeqIO

in_file = "$expData"
o_file = "output.txt"
Cutoff = $cutoff

def calculate_gc(seq):
    gc_count = seq.count("G") + seq.count("C")
    return gc_count / len(seq) if len(seq) > 0 else 0

with open(in_file, "r") as fasta, open(o_file, "w") as output:
    for record in SeqIO.parse(fasta, "fasta"):
        gc_content = calculate_gc(str(record.seq).upper())
        if gc_content > Cutoff:
            output.write(">" + record.id + "\\n" + str(record.seq) + "\\n")
        """
    }


workflow {
input_file = Channel.fromPath(params.input)
GC_Filter(input_file, params.cutoff)
}
