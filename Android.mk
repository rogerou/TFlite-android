LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)


SOURCES := \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/*.cc) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/*.cc) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/internal/*.cc) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/internal/optimized/*.cc) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/internal/reference/*.cc) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/*.c) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/*.c) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/internal/*.c) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/internal/optimized/*.c) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/internal/reference/*.c) \
			$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/downloads/farmhash/src/farmhash.cc)

CORE_CC_ALL_SRCS := $(sort $(SOURCES))
CORE_CC_EXCLUDE_SRCS := \
$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/*test.cc) \
$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/*/*test.cc) \
$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/*/*/*test.cc) \
$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/*/*/*/*test.cc) \
$(wildcard $(LOCAL_PATH)/include/tensorflow/contrib/lite/kernels/test_util.cc) \


TF_LITE_CC_SRCS := $(filter-out $(CORE_CC_EXCLUDE_SRCS), $(CORE_CC_ALL_SRCS))

INCLUDES := \
		$(LOCAL_PATH)/include   \
		$(LOCAL_PATH)/include/tensorflow/contrib/lite/downloads/flatbuffers/include \
		$(LOCAL_PATH)/include/tensorflow/contrib/lite/downloads/absl   \
		$(LOCAL_PATH)/include/tensorflow/contrib/lite/downloads/eigen	\
		$(LOCAL_PATH)/include/tensorflow/contrib/lite/downloads/gemmlowp	\
		$(LOCAL_PATH)/include/tensorflow/contrib/lite/downloads/neon_2_sse	\
		$(LOCAL_PATH)/include/tensorflow/contrib/lite/downloads/farmhash/src	\
		$(LOCAL_PATH)/include/tensorflow/contrib/lite/../../../	\



LDFLAGS := \
			-Wl,--no-export-dynamic \
			-Wl,--exclude-libs,ALL \
			-Wl,--gc-sections \
			-Wl,--as-needed
	

LDLIBS := \
	-lstdc++ \
	-lpthread \
	-lm \
	-ldl			

CXXFLAGS := -std=c++11 -frtti

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
	CXXFLAGS+=		
					-mfpu=neon-vfpv4 \
					-mfloat-abi=softfp \
					-funsafe-math-optimizations \
					-ftree-vectorize
endif


ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
	CXXFLAGS+=		-march=armv8-a\
					-funsafe-math-optimizations \
					-ftree-vectorize
						
endif


LOCAL_EXPORT_C_INCLUDES 	:= $(INCLUDES)
LOCAL_C_INCLUDES 			+= $(INCLUDES)
LOCAL_CPPFLAGS              := $(CXXFLAGS)
LOCAL_SRC_FILES				:= $(TF_LITE_CC_SRCS)
LOCAL_EXPORT_LDLIBS         := $(LDLIBS)
LOCAL_ARM_MODE              := arm
LOCAL_MODULE := tensorflow-lite


include $(BUILD_STATIC_LIBRARY)


	
