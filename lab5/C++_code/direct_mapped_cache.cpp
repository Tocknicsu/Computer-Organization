#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content{
    bool v;
    unsigned int  tag;
};

const int K=1024;

void simulate(int cache_size, int block_size){
    unsigned int tag,index,x;

    int offset_bit = (int) log2(block_size);
    int index_bit = (int) log2(cache_size/block_size);
    int line = cache_size>>(offset_bit);

    cache_content *cache =new cache_content[line];
    //printf("cache line: %d\n", line);

    for(int j=0;j<line;j++)
        cache[j].v=false;

    FILE * fp=fopen("DCACHE.txt","r");					//read file
    int total = 0, miss = 0;

    while(fscanf(fp,"%x",&x)!=EOF){
        //printf("%x ", x);
        index=(x>>offset_bit)&(line-1);
        tag=x>>(index_bit+offset_bit);
        if(cache[index].v && cache[index].tag==tag){
            cache[index].v=true; 			//hit
        }
        else{						
            cache[index].v=true;			//miss
            miss++;
            cache[index].tag=tag;
        }
        total++;
    }
    printf("Cache size: %7d Block size: %7d ", cache_size, block_size);
    printf("miss rate: %.6f%%\n", (double(miss) * 100) / double(total));
    fclose(fp);

    delete [] cache;
}

int main(){
    // Let us simulate 4KB cache with 16B blocks
    for(int i = 32 ; i <= 512 ; i <<= 1)
        for(int j = 1 ; j <= 32 ; j <<= 1){
            simulate(i, j);
        }
    return 0;
}
