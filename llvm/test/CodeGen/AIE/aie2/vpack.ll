; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;
; This file is licensed under the Apache License v2.0 with LLVM Exceptions.
; See https://llvm.org/LICENSE.txt for license information.
; SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
;
; (c) Copyright 2023-2024 Advanced Micro Devices, Inc. or its affiliates
; RUN: llc -O2 -mtriple=aie2 %s -o - | FileCheck %s

define <32 x i8> @test_pack_d8_d16_dyn(<32 x i16> %v, i32 %sign) {
; CHECK-LABEL: test_pack_d8_d16_dyn:
; CHECK:         .p2align 4
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    nopb ; nopa ; nops ; ret lr ; nopm ; nopv
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    mov crPackSign, r0 // Delay Slot 3
; CHECK-NEXT:    vpack.d8.d16 wl0, x2 // Delay Slot 2
; CHECK-NEXT:    mov crPackSign, #0 // Delay Slot 1
entry:
  %0 = tail call <32 x i8> @llvm.aie2.pack.I8.I16(<32 x i16> %v, i32 %sign)
  ret <32 x i8> %0
}

define <32 x i8> @test_pack_d4_d8_dyn(<64 x i8> %v, i32 %sign) {
; CHECK-LABEL: test_pack_d4_d8_dyn:
; CHECK:         .p2align 4
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    nopb ; nopa ; nops ; ret lr ; nopm ; nopv
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    mov crPackSign, r0 // Delay Slot 3
; CHECK-NEXT:    vpack.d4.d8 wl0, x2 // Delay Slot 2
; CHECK-NEXT:    mov crPackSign, #0 // Delay Slot 1
entry:
  %0 = bitcast <64 x i8> %v to <32 x i16>
  %1 = tail call <32 x i8> @llvm.aie2.pack.I4.I8(<32 x i16> %0, i32 %sign)
  ret <32 x i8> %1
}

define <32 x i8> @test_pack_s8_s16(<32 x i16> %v) {
; CHECK-LABEL: test_pack_s8_s16:
; CHECK:         .p2align 4
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    ret lr
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    nop // Delay Slot 3
; CHECK-NEXT:    vpack.s8.s16 wl0, x2 // Delay Slot 2
; CHECK-NEXT:    nop // Delay Slot 1
entry:
  %0 = tail call <32 x i8> @llvm.aie2.pack.I8.I16(<32 x i16> %v, i32 1)
  ret <32 x i8> %0
}

define <32 x i8> @test_pack_d8_d16(<32 x i16> %v) {
; CHECK-LABEL: test_pack_d8_d16:
; CHECK:         .p2align 4
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    ret lr
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    nop // Delay Slot 3
; CHECK-NEXT:    vpack.d8.d16 wl0, x2 // Delay Slot 2
; CHECK-NEXT:    nop // Delay Slot 1
entry:
  %0 = tail call <32 x i8> @llvm.aie2.pack.I8.I16(<32 x i16> %v, i32 0)
  ret <32 x i8> %0
}

define <32 x i8> @test_pack_s4_s8(<64 x i8> %v) {
; CHECK-LABEL: test_pack_s4_s8:
; CHECK:         .p2align 4
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    ret lr
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    nop // Delay Slot 3
; CHECK-NEXT:    vpack.s4.s8 wl0, x2 // Delay Slot 2
; CHECK-NEXT:    nop // Delay Slot 1
entry:
  %0 = bitcast <64 x i8> %v to <32 x i16>
  %1 = tail call <32 x i8> @llvm.aie2.pack.I4.I8(<32 x i16> %0, i32 1)
  ret <32 x i8> %1
}

define <32 x i8> @test_pack_d4_d8(<64 x i8> %v) {
; CHECK-LABEL: test_pack_d4_d8:
; CHECK:         .p2align 4
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    ret lr
; CHECK-NEXT:    nop // Delay Slot 5
; CHECK-NEXT:    nop // Delay Slot 4
; CHECK-NEXT:    nop // Delay Slot 3
; CHECK-NEXT:    vpack.d4.d8 wl0, x2 // Delay Slot 2
; CHECK-NEXT:    nop // Delay Slot 1
entry:
  %0 = bitcast <64 x i8> %v to <32 x i16>
  %1 = tail call <32 x i8> @llvm.aie2.pack.I4.I8(<32 x i16> %0, i32 0)
  ret <32 x i8> %1
}

declare <32 x i8> @llvm.aie2.pack.I4.I8(<32 x i16>, i32)
declare <32 x i8> @llvm.aie2.pack.I8.I16(<32 x i16>, i32)
