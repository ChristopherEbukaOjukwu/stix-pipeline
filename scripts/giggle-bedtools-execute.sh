while IFS= read -r line; do
        chr=$( echo "$line" | cut -f1 )
        s=$( echo "$line" | cut -f2 )
        e=$( echo "$line" | cut -f3 )
        gene=$( echo "$line" | cut -f4 )

        hits=$( bedtools intersect -a sorted_hg19.protein_coding.bed.gz -b <(giggle search -i input.d/ -v -r $chr:$s-$e | cut -f 5-7) | cut -f4 | paste -sd, - )
        echo -e "$gene\t$hits"



done < <(zcat sorted_genelist.bed.gz)