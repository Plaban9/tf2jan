#include <iostream>
#include <vector>
using namespace std;

int main() 
{
    int n_trms,i,count=1;
    vector <int> seq = {7,2,0,7};
    vector <int>::iterator it;   
    
    cout<<"\nEnter no. of terms (greater than 6): ";
    cin>>n_trms;
    
    for( it = seq.begin() ; it < seq.end() ; ++it )
        cout<<*it<<" ";
    
    for( i = 4 ; i < n_trms  ; ++i )
    {    
        seq.push_back( seq[i-4] + count );
        count++;
        cout<<seq[i]<<" ";
    }   
    
    return 0;
    
}//end_of_code
