################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
L138_LCDK_aic3106_init.obj: D:/Softwares/CCSv9_software/DSP_LIB_C6748/support_files/L138_LCDK_aic3106_init.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"D:/Softwares/CCSv9_software/c6000_7.4.4/bin/cl6x" -mv6740 --abi=coffabi -g --include_path="D:/ccsv9_workspace/w2/masking" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/support_files" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/board_support_lib/inc" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/support_files" --include_path="D:/Softwares/CCS extra files" --include_path="D:/Softwares/CCSv9_software/c6000_7.4.4/include" --define=c6748 --diag_wrap=off --display_error_number --diag_warning=225 --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

%.obj: ../%.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"D:/Softwares/CCSv9_software/c6000_7.4.4/bin/cl6x" -mv6740 --abi=coffabi -g --include_path="D:/ccsv9_workspace/w2/masking" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/support_files" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/board_support_lib/inc" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/support_files" --include_path="D:/Softwares/CCS extra files" --include_path="D:/Softwares/CCSv9_software/c6000_7.4.4/include" --define=c6748 --diag_wrap=off --display_error_number --diag_warning=225 --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

vectors_intr.obj: D:/Softwares/CCSv9_software/DSP_LIB_C6748/support_files/vectors_intr.asm $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C6000 Compiler'
	"D:/Softwares/CCSv9_software/c6000_7.4.4/bin/cl6x" -mv6740 --abi=coffabi -g --include_path="D:/ccsv9_workspace/w2/masking" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/support_files" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/board_support_lib/inc" --include_path="D:/Softwares/CCSv9_software/DSP_LIB_C6748/support_files" --include_path="D:/Softwares/CCS extra files" --include_path="D:/Softwares/CCSv9_software/c6000_7.4.4/include" --define=c6748 --diag_wrap=off --display_error_number --diag_warning=225 --preproc_with_compile --preproc_dependency="$(basename $(<F)).d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


