#include <stdio.h>
#include <stdlib.h>
#include "system.h"
#include "sys/alt_timestamp.h"
#include "alt_types.h"
#include "altera_avalon_timer_regs.h"

// Instruction multi-cycle (MAC_OP) : n(0) = 1
#define custom_mac_op(A, B) ALT_CI_MAC_FILTRE_INTERFACE_0(ALT_CI_MAC_FILTRE_INTERFACE_0_N_MASK, A, B)

// Instruction combinatoire (FILTRE_MOYENNEUR) : n(0) = 0
#define filtre_moyenneur_custom(A, B) ALT_CI_MAC_FILTRE_INTERFACE_0((~ALT_CI_MAC_FILTRE_INTERFACE_0_N) << 1, A, B)

#define IMAGE_SIZE 16
#define KERNEL_SIZE 9

//int input_image[IMAGE_SIZE] = { /* données d'image simulée */ };
int input_image[IMAGE_SIZE] = {
    120, 135, 125, 130,
    115, 140, 145, 135,
    125, 150, 155, 140,
    130, 145, 135, 125
};
int output_custom[IMAGE_SIZE] = {0};
int output_software[IMAGE_SIZE] = {0};
int kernel[KERNEL_SIZE] = {1, 2, 1, 2, 4, 2, 1, 2, 1}; // Kernel Gaussian

// Fonction d'initialisation du timestamp
int init_timestamp(void) {
    // Vérifier si le timer est disponible
    if(alt_timestamp_start() < 0) {
        printf("ERROR: No timestamp timer available\n");
        return -1;
    } else {
        printf("Timestamp timer initialized\n");
        printf("Timestamp frequency: %lu Hz\n", 
               (unsigned long)alt_timestamp_freq());
        return 0;
    }
}


void convolution_3x3_custom(int* input, int* output, int* kernel, int width, int height) {
    int i, j, k, l;
    int sum;
    
    for(i = 1; i < height-1; i++) {
        for(j = 1; j < width-1; j++) {
            sum = 0;
            
            for(k = -1; k <= 1; k++) {
                for(l = -1; l <= 1; l++) {
                    int pixel = input[(i+k)*width + (j+l)];
                    int weight = kernel[(k+1)*3 + (l+1)];
                    
                    sum = custom_mac_op(pixel, weight);
                }
            }
            output[i*width + j] = sum >> 4;
        }
    }
}

void convolution_3x3_software(int* input, int* output, int* kernel, int width, int height) {
    int i, j, k, l;
    int sum;
    
    for(i = 1; i < height-1; i++) {
        for(j = 1; j < width-1; j++) {
            sum = 0;
            for(k = -1; k <= 1; k++) {
                for(l = -1; l <= 1; l++) {
                    sum += input[(i+k)*width + (j+l)] * kernel[(k+1)*3 + (l+1)];
                }
            }
            output[i*width + j] = sum >> 4;
        }
    }
}

void filtre_moyenneur_custom_line(int* in, int* out, int width){
    int i;
	for (i = 0; i < width-1; i++) {
        out[i] = filtre_moyenneur_custom(in[i], in[i+1]);
    }
}

void filtre_moyenneur_software(int* in, int* out, int width){
    int i;
	for (i = 0; i < width-1; i++) {
        out[i] = (3*in[i] + 1*in[i+1]) >> 2;
    }
}


int main() {
    printf("Debut du projet instructions personnalisees\n");

    // Mesure du temps version custom
    alt_timestamp_type start_time, end_time;
    double time_custom, time_software;
	
	// Initialiser le timestamp
    if(init_timestamp() != 0) {
        printf("Cannot continue without timestamp timer\n");
        return -1;
    }
	
	printf("cas instrustion multicycle : convolution_3x3_custom \n");
	start_time = alt_timestamp();
	
    convolution_3x3_custom(input_image, output_custom, kernel, 4, 4);
	
	end_time = alt_timestamp();
	
    // Calculer le temps écoulé
    time_custom = ((double)(end_time - start_time)) / alt_timestamp_freq();
	

	printf("Temps version custom : %lu cycles\n", (unsigned long)(end_time - start_time));
    printf("Temps version custom : %.6f seconds\n", time_custom);
    printf("Temps version custom : %.3f ms\n\n", time_custom * 1000.0);
	
    
    // Mesure du temps version software
    start_time = alt_timestamp();
	
    convolution_3x3_software(input_image, output_software, kernel, 4, 4);
	
	end_time = alt_timestamp();

    // Calculer le temps écoulé
    time_software = ((double)(end_time - start_time)) / alt_timestamp_freq();

	printf("Temps version software : %lu cycles\n", (unsigned long)(end_time - start_time));
    printf("Temps version software : %.6f seconds\n", time_software);
    printf("Temps version software : %.3f ms\n\n", time_software * 1000.0);
    printf("Acceleration: %.2fx\n", time_software/time_custom);
    
    
	
	
	
	printf("\ncas instrustion combinatoire : filtre_moyenneur_custom \n");
	
	start_time = alt_timestamp();
	
    filtre_moyenneur_custom_line(input_image, output_software, IMAGE_SIZE);
	
	end_time = alt_timestamp();
	
    // Calculer le temps écoulé
    time_custom = ((double)(end_time - start_time)) / alt_timestamp_freq();

	printf("Temps version custom : %lu cycles\n", (unsigned long)(end_time - start_time));
    printf("Temps version custom : %.6f seconds\n", time_custom);
    printf("Temps version custom : %.3f ms\n\n", time_custom * 1000.0);
	
    
    // Mesure du temps version software
    start_time = alt_timestamp();
	
    filtre_moyenneur_software(input_image, output_software, IMAGE_SIZE);
	
	end_time = alt_timestamp();

    // Calculer le temps écoulé
    time_software = ((double)(end_time - start_time)) / alt_timestamp_freq();

	printf("Temps version software : %lu cycles\n", (unsigned long)(end_time - start_time));
    printf("Temps version software : %.6f seconds\n", time_software);
    printf("Temps version software : %.3f ms\n\n", time_software * 1000.0);
    printf("Acceleration: %.2fx\n", time_software/time_custom);
	
    
    return 0;
}