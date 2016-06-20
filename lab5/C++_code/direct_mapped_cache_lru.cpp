#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content{
    bool v;
    unsigned int  tag;
    unsigned int  last;
};

const int K=1024;

void simulate(int cache_size, int way){
    const int block_size = 64;
    unsigned int tag,index,x;

    int offset_bit = (int)log2(block_size);
    int index_bit = (int) log2((cache_size/block_size)/way);
    int index_size = (cache_size / block_size) / way;

    cache_content cache[index_size][way];

    
    //printf("cache line: %d\n", line);
    for(int i = 0 ; i < index_size ; i++)
        for(int j = 0 ; j < way ; j++)
            cache[i][j].v = 0;

    FILE *fp=fopen("RADIX.txt","r");					//read file
    int total = 0, miss = 0;

    while(fscanf(fp,"%x",&x)!=EOF){
        //printf("%x ", x);
        index = (x>>offset_bit)&(index_size-1);
        tag = x>>(index_bit+offset_bit);
        bool done = false;
        for(int i = 0 ; i < way ; i++){
            if(cache[index][i].v && cache[index][i].tag == tag){
                //hit
                cache[index][i].last = total;
                done = true;
                break;
            }
        }
        if(!done)
            miss++;
        if(!done){
            for(int i = 0 ; i < way ; i++){
                if(cache[index][i].v == false){
                    cache[index][i].v = true;
                    cache[index][i].tag = tag;
                    cache[index][i].last = total;
                    done = true;
                    break;
                }
            }
        }
        if(!done){
            unsigned int replace = 0x3f3f3f3f;
            int replace_way;
            for(int i = 0 ; i < way ; i++){
                if(cache[index][i].last < replace){
                    replace_way = i;
                    replace = cache[index][i].last;
                }
            }
            cache[index][replace_way].tag = tag;
            cache[index][replace_way].last = total;
        }
        total++;
    }
    printf("Cache size: %7d way: %7d ", cache_size, way);
    printf("miss rate: %.6f%%\n", (double(miss) * 100) / double(total));
    fclose(fp);

}

int main(){
    for(int i = 1 ; i <= 32 ; i <<= 1)
        for(int j = 1 ; j <= 8 ; j <<= 1){
            simulate(i*K, j);
        }
    return 0;
}
