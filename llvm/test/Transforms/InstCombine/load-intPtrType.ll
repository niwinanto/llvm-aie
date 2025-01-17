; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
;
; This file is licensed under the Apache License v2.0 with LLVM Exceptions.
; See https://llvm.org/LICENSE.txt for license information.
; SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
;
; (c) Copyright 2024 Advanced Micro Devices, Inc. or its affiliates

; RUN: opt -passes=instcombine -S < %s | FileCheck %s

target datalayout = "p:20:32"

define i20 @load_intPtrType(ptr %x) {
; CHECK-LABEL: @load_intPtrType(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = load i32, ptr [[X:%.*]], align 4
; CHECK-NEXT:    [[TR:%.*]] = trunc i32 [[B]] to i20
; CHECK-NEXT:    ret i20 [[TR]]
;
entry:
  %b = load i32, ptr %x
  %tr = trunc i32 %b to i20
  ret i20 %tr
}

define ptr @load_intPtrType_to_ptr(ptr %x) {
; CHECK-LABEL: @load_intPtrType_to_ptr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B1:%.*]] = load i20, ptr [[X:%.*]], align 4
; CHECK-NEXT:    [[C:%.*]] = inttoptr i20 [[B1]] to ptr
; CHECK-NEXT:    ret ptr [[C]]
;
entry:
  %b = load i32, ptr %x
  %tr = trunc i32 %b to i20
  %c = inttoptr i20 %tr to ptr
  ret ptr %c
}
