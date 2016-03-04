#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void test()
{
	printf("*****0***");
        char *buf=NULL, *p=NULL;
        FILE *config_fp=NULL;
	printf("*****1***");
        config_fp=fopen("config.txt", "r");
        if(config_fp==NULL)
        {
                fclose(config_fp);
                return;
        }
	printf("*****2***");
        buf=(char *)malloc(1024*sizeof(char));
        while(1){
                p=fgets(buf, 1024, config_fp);
                if(!p)
                        break;
                printf("**************%s******\n", buf);
		printf("****3***");
        }
}


int main()  
{  
    char szTest[1000] = {0};  
    int len = 0;  
    char *dev_process=NULL;
    dev_process=(char *)malloc(1000*sizeof(char));
    char *dev_name=NULL;
    dev_name=(char *)malloc(1000*sizeof(char));
    FILE *fp = fopen("config.txt", "r");  
    if(NULL == fp)  
    {  
        printf("failed to open dos.txt\n");  
        return 1;  
    }  
  
    while(!feof(fp))  
    {  
        memset(szTest, 0, sizeof(szTest));  
        fgets(szTest, sizeof(szTest) - 1, fp);
	if(*szTest ==0)
		break;
	dev_process=strstr( szTest,":");
	len=dev_process - szTest;
	printf("len=%d\n", len);
	strncpy(dev_name, szTest, len);
        printf("%s", szTest); 
	printf("%s\n", dev_process+1);
	printf("%d\n",atoi(dev_process+1));
	printf("%s\n", dev_name);
    }  
  
    fclose(fp);  
 
    printf("over");
    printf("\n");  
  
    return 0;  
}  
