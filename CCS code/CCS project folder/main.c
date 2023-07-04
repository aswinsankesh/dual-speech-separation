/* separation of hello of two persons... extracting one speech from 2 speech signals */

#include "L138_LCDK_aic3106_init.h"
#include "binMask_hello.h"
#include <math.h>

#define q   6      /* for 2^6 = 64 points */
#define N   (1<<q)      /* N-point FFT, iFFT */
# define PI 3.1415926535897

typedef float real;
typedef struct{real Re; real Im;} complex;

extern int16_t *pingIN, *pingOUT, *pongIN, *pongOUT;
volatile int buffer_full = 0;
int procBuffer;


float left_buffer[BUFCOUNT/2],right_buffer[BUFCOUNT/2];
complex v[N], scratch[N];
int index = 0;


interrupt void interrupt4(void) // interrupt service routine
{
 switch(EDMA_3CC_IPR)
 {
 case 1: // TCC = 0
 procBuffer = PING; // process ping
 EDMA_3CC_ICR = 0x0001; // clear EDMA3 IPR bit TCC
 break;
 case 2: // TCC = 1
 procBuffer = PONG; // process pong
 EDMA_3CC_ICR = 0x0002; // clear EDMA3 IPR bit TCC
 break;
 default: // may have missed an interrupt
 EDMA_3CC_ICR = 0x0003; // clear EDMA3 IPR bits 0 and 1
 break;
 }
 EVTCLR0 = 0x00000100;
 buffer_full = 1; // flag EDMA3 transfer
 return;
}

//fft and ifft using Cooley-Tukey algorithm for reduced time complexity.
void fft( complex *v, int n, complex *tmp )
{
  if(n>1) {         /* otherwise, do nothing and return */
    int k,m;    complex z, w, *vo, *ve;
    ve = tmp; vo = tmp+n/2;
    for(k=0; k<n/2; k++) {
      ve[k] = v[2*k];
      vo[k] = v[2*k+1];
    }
    fft( ve, n/2, v );      /* FFT on even-indexed elements of v[] */
    fft( vo, n/2, v );      /* FFT on odd-indexed elements of v[] */
    for(m=0; m<n/2; m++) {
      w.Re = cos(2*PI*m/(double)n);
      w.Im = -sin(2*PI*m/(double)n);
      z.Re = w.Re*vo[m].Re - w.Im*vo[m].Im; /* Re(w*vo[m]) */
      z.Im = w.Re*vo[m].Im + w.Im*vo[m].Re; /* Im(w*vo[m]) */
      v[  m  ].Re = ve[m].Re + z.Re;
      v[  m  ].Im = ve[m].Im + z.Im;
      v[m+n/2].Re = ve[m].Re - z.Re;
      v[m+n/2].Im = ve[m].Im - z.Im;
    }
  }
  return;
}


void ifft( complex *v, int n, complex *tmp )
{
  if(n>1) {         /* otherwise, do nothing and return */
    int k,m;    complex z, w, *vo, *ve;
    ve = tmp; vo = tmp+n/2;
    for(k=0; k<n/2; k++) {
      ve[k] = v[2*k];
      vo[k] = v[2*k+1];
    }
    ifft( ve, n/2, v );     /* FFT on even-indexed elements of v[] */
    ifft( vo, n/2, v );     /* FFT on odd-indexed elements of v[] */
    for(m=0; m<n/2; m++) {
      w.Re = cos(2*PI*m/(double)n);
      w.Im = sin(2*PI*m/(double)n);
      z.Re = w.Re*vo[m].Re - w.Im*vo[m].Im; /* Re(w*vo[m]) */
      z.Im = w.Re*vo[m].Im + w.Im*vo[m].Re; /* Im(w*vo[m]) */
      v[  m  ].Re = (ve[m].Re + z.Re);
      v[  m  ].Im = (ve[m].Im + z.Im);
      v[m+n/2].Re = (ve[m].Re - z.Re);
      v[m+n/2].Im = (ve[m].Im - z.Im);
    }
  }
  return;
}

void process_buffer(void)
{
 int16_t *inBuf, *outBuf; // pointers to process buffers
 int i;
 if (procBuffer == PING) // use ping or pong buffers
 {
 inBuf = pingIN;
 outBuf = pingOUT;
 }
 if (procBuffer == PONG)
 {
 inBuf = pongIN;
 outBuf = pongOUT;
 }
 for (i = 0; i < (BUFCOUNT/2) ; i++)
 {
     //getting 64 samples from the real-time audio input

      left_buffer[i] = *inBuf++;
      right_buffer[i] = *inBuf++;

      v[i].Re =  left_buffer[i];
      v[i].Im = 0.0;

 }

  fft( v, N, scratch ); //performing 64-pt fft,which is a part of stft

  //multipliying the fft with the mask of hello_female
  for(i=0;i<N;i++){
    v[i].Re = v[i].Re * binMask[index][i];
    v[i].Im = v[i].Im * binMask[index][i];
  }
  index = (index+1)%ROWS; //for the future samples we are incrementing the binMask to next column
  //bcoz columns of binMask represent frequency, and rows represent time domain.



 ifft( v, N, scratch ); //take inverse fft for the masked signal which contains only female speech.


 for (i = 0; i < (BUFCOUNT/2) ; i++)
 {

      *outBuf++ = sqrt(v[i].Re*v[i].Re + v[i].Im*v[i].Im);
      *outBuf++ = sqrt(v[i].Re*v[i].Re + v[i].Im*v[i].Im);//setting the right channel val same as left channel
 }


 buffer_full = 0; // indicate that buffer has been processed
 return;
}

int main(void)
{
 L138_initialise_edma(FS_8000_HZ,ADC_GAIN_0DB,DAC_ATTEN_0DB,LCDK_LINE_INPUT);
  while(1)
  {
  while (!buffer_full);
  process_buffer();  //perform masking for 64 samples as a whole.
   }
}
