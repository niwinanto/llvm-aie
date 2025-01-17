; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;
; This file is licensed under the Apache License v2.0 with LLVM Exceptions.
; See https://llvm.org/LICENSE.txt for license information.
; SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
;
; (c) Copyright 2023-2024 Advanced Micro Devices, Inc. or its affiliates
; RUN: llc -O2 -mtriple=aie2 --issue-limit=1 --enable-aie-hardware-loops %s -o - | FileCheck %s

; Check that we recognize the two level nested loops as hardware loop candidates.
; In the LLVM IR input, the loop guards have been removed to allow for a simpler
; branch structure. It is guaranteed that %size and %size2 are greater than 0.
; In both loops, the trip count is decremented by one to obtain the backedge-taken
; count

define void @nested(ptr nocapture %out, ptr nocapture readonly %in, i32 noundef %size, i32 noundef %size2) {
; CHECK-LABEL: nested:
; CHECK:         .p2align 4
; CHECK-NEXT:  // %bb.0: // %for.cond3.preheader.lr.ph
; CHECK-NEXT:    nopa ; nopb ; j #.LBB0_3
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    mova r3, #0 // Delay Slot 4
; CHECK-NEXT:    mova r4, #2 // Delay Slot 3
; CHECK-NEXT:    movxm p2, #.LBB0_1 // Delay Slot 2
; CHECK-NEXT:    lda r2, [p0, #0] // Delay Slot 1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_1: // %for.body6
; CHECK-NEXT:    // Parent Loop BB0_3 Depth=1
; CHECK-NEXT:    // => This Inner Loop Header: Depth=2
; CHECK-NEXT:    nopb ; nopa ; nops ; lshl r7, r6, r4; nopm ; nopv
; CHECK-NEXT:    mov dj0, r7
; CHECK-NEXT:    lda r7, [p3, dj0]
; CHECK-NEXT:    nop
; CHECK-NEXT:    nop
; CHECK-NEXT:    jnzd r5, r5, p2
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    add r6, r6, #1 // Delay Slot 3
; CHECK-NEXT:    add r2, r2, r7 // Delay Slot 2
; CHECK-NEXT:    st r2, [p0, #0] // Delay Slot 1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  // %bb.2: // %for.cond3.for.cond.cleanup5_crit_edge
; CHECK-NEXT:    // in Loop: Header=BB0_3 Depth=1
; CHECK-NEXT:    nopa ; nopb ; add r3, r3, #1; nopm
; CHECK-NEXT:    eq r5, r0, r3
; CHECK-NEXT:    jnz r5, #.LBB0_4
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    nop // Delay Slot 3
; CHECK-NEXT:    nop // Delay Slot 2
; CHECK-NEXT:    nop // Delay Slot 1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_3: // %for.cond3.preheader
; CHECK-NEXT:    // =>This Loop Header: Depth=1
; CHECK-NEXT:    // Child Loop BB0_1 Depth 2
; CHECK-NEXT:    lshl r5, r3, r4
; CHECK-NEXT:    mov dj0, r5
; CHECK-NEXT:    lda p3, [p1, dj0]
; CHECK-NEXT:    j #.LBB0_1
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    nop // Delay Slot 3
; CHECK-NEXT:    mova r6, #0 // Delay Slot 2
; CHECK-NEXT:    add.nc r5, r1, #-1 // Delay Slot 1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_4: // %for.cond.cleanup
; CHECK-NEXT:    nopa ; ret lr
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    nop // Delay Slot 3
; CHECK-NEXT:    nop // Delay Slot 2
; CHECK-NEXT:    nop // Delay Slot 1
for.cond3.preheader.lr.ph:
  %out.promoted22 = load i32, ptr %out, align 4
  br label %for.cond3.preheader

for.cond3.preheader:
  %out.promoted23 = phi i32 [ %out.promoted22, %for.cond3.preheader.lr.ph ], [ %add, %for.cond3.for.cond.cleanup5_crit_edge ]
  %i.021 = phi i32 [ 0, %for.cond3.preheader.lr.ph ], [ %inc9, %for.cond3.for.cond.cleanup5_crit_edge ]
  %0 = trunc i32 %i.021 to i20
  %arrayidx = getelementptr inbounds ptr, ptr %in, i20 %0
  %1 = load ptr, ptr %arrayidx, align 4
  br label %for.body6

for.cond.cleanup:
  ret void

for.cond3.for.cond.cleanup5_crit_edge:
  %inc9 = add nuw nsw i32 %i.021, 1
  %exitcond24.not = icmp eq i32 %inc9, %size
  br i1 %exitcond24.not, label %for.cond.cleanup, label %for.cond3.preheader

for.body6:
  %add19 = phi i32 [ %out.promoted23, %for.cond3.preheader ], [ %add, %for.body6 ]
  %j.018 = phi i32 [ 0, %for.cond3.preheader ], [ %inc, %for.body6 ]
  %2 = trunc i32 %j.018 to i20
  %arrayidx7 = getelementptr inbounds i32, ptr %1, i20 %2
  %3 = load i32, ptr %arrayidx7, align 4
  %add = add nsw i32 %add19, %3
  store i32 %add, ptr %out, align 4
  %inc = add nuw nsw i32 %j.018, 1
  %exitcond.not = icmp eq i32 %inc, %size2
  br i1 %exitcond.not, label %for.cond3.for.cond.cleanup5_crit_edge, label %for.body6
}
