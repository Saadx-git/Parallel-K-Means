.PHONY: build clean run run-seq run-parallel help all profile-seq profile-parallel profile-both kcachegrind-seq kcachegrind-parallel

BUILD_DIR := build
SEQ_EXECUTABLE := $(BUILD_DIR)/main
PARALLEL_EXECUTABLE := $(BUILD_DIR)/main_parallel
PROFILE_DIR := callgrind_results

# Default target
all: build

# Build the project
build:
	@mkdir -p $(BUILD_DIR)
	@cd $(BUILD_DIR) && cmake .. && make

# Run sequential version
run-seq: build
	@echo "Running sequential K-Means..."
	@$(SEQ_EXECUTABLE)

# Run parallel version
run-parallel: build
	@echo "Running parallel K-Means..."
	@$(PARALLEL_EXECUTABLE)

# Run both versions
run-both: build
	@echo "Running sequential K-Means..."
	@$(SEQ_EXECUTABLE)
	@echo ""
	@echo "Running parallel K-Means..."
	@$(PARALLEL_EXECUTABLE)

# Alias for run-both
run: run-both

# Clean build directory
clean:
	@rm -rf $(BUILD_DIR)
	@echo "Build directory cleaned."

# Profile targets using Callgrind
profile-seq: build
	@mkdir -p $(PROFILE_DIR)
	@echo "Profiling sequential version with Callgrind..."
	@valgrind --tool=callgrind --callgrind-out-file=$(PROFILE_DIR)/callgrind.seq $(SEQ_EXECUTABLE)
	@echo "Sequential profile saved to: $(PROFILE_DIR)/callgrind.seq"

profile-parallel: build
	@mkdir -p $(PROFILE_DIR)
	@echo "Profiling parallel version with Callgrind..."
	@valgrind --tool=callgrind --callgrind-out-file=$(PROFILE_DIR)/callgrind.parallel $(PARALLEL_EXECUTABLE)
	@echo "Parallel profile saved to: $(PROFILE_DIR)/callgrind.parallel"

profile-both: profile-seq profile-parallel
	@echo ""
	@echo "Both profiles completed!"
	@echo "Sequential: $(PROFILE_DIR)/callgrind.seq"
	@echo "Parallel:   $(PROFILE_DIR)/callgrind.parallel"

# View profiles with KCachegrind
kcachegrind-seq: profile-seq
	@echo "Opening sequential profile in KCachegrind..."
	@kcachegrind $(PROFILE_DIR)/callgrind.seq &

kcachegrind-parallel: profile-parallel
	@echo "Opening parallel profile in KCachegrind..."
	@kcachegrind $(PROFILE_DIR)/callgrind.parallel &

kcachegrind-both: profile-both
	@echo "Opening both profiles in KCachegrind..."
	@kcachegrind $(PROFILE_DIR)/callgrind.seq &
	@kcachegrind $(PROFILE_DIR)/callgrind.parallel &

# Generate performance report
report: profile-both
	@echo "======================================"
	@echo "   K-MEANS PERFORMANCE REPORT"
	@echo "======================================"
	@echo ""
	@echo "Profile files generated:"
	@ls -lh $(PROFILE_DIR)/callgrind.*
	@echo ""
	@echo "To analyze profiles, use:"
	@echo "  make kcachegrind-seq       - View sequential profile"
	@echo "  make kcachegrind-parallel  - View parallel profile"
	@echo "  make kcachegrind-both      - View both profiles"
	@echo ""
	@echo "Or use callgrind_annotate for text-based reports:"
	@echo "  callgrind_annotate $(PROFILE_DIR)/callgrind.seq"
	@echo "  callgrind_annotate $(PROFILE_DIR)/callgrind.parallel"

# Help target
help:
	@echo "K-Means Makefile Usage:"
	@echo ""
	@echo "Build targets:"
	@echo "  make build         - Build both sequential and parallel executables"
	@echo ""
	@echo "Run targets:"
	@echo "  make run-seq       - Build and run sequential version"
	@echo "  make run-parallel  - Build and run parallel version"
	@echo "  make run-both      - Build and run both versions (default)"
	@echo "  make run           - Alias for run-both"
	@echo ""
	@echo "Profiling targets (using Callgrind):"
	@echo "  make profile-seq      - Profile sequential version"
	@echo "  make profile-parallel - Profile parallel version"
	@echo "  make profile-both     - Profile both versions"
	@echo ""
	@echo "Analysis targets (using KCachegrind):"
	@echo "  make kcachegrind-seq      - Open sequential profile in KCachegrind"
	@echo "  make kcachegrind-parallel - Open parallel profile in KCachegrind"
	@echo "  make kcachegrind-both     - Open both profiles in KCachegrind"
	@echo ""
	@echo "Report targets:"
	@echo "  make report        - Generate performance report and show profile files"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean         - Remove build directory"
	@echo "  make help          - Display this help message"
