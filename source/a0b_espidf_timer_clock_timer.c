//
//  Copyright (C) 2026, Vadim Godunko
//
//  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//

#include <freertos/FreeRTOS.h>
#include <esp_timer.h>

static portMUX_TYPE timer_spinlock = portMUX_INITIALIZER_UNLOCKED;

void __a0b_espidf_timer_ENTER_CRITICAL()
{
    if(xPortInIsrContext())
    {
        taskENTER_CRITICAL_ISR(&timer_spinlock);
    } else {
        taskENTER_CRITICAL(&timer_spinlock);
    }
}

void __a0b_espidf_timer_EXIT_CRITICAL()
{
    if(xPortInIsrContext())
    {
        taskEXIT_CRITICAL_ISR(&timer_spinlock);
    } else {
        taskEXIT_CRITICAL(&timer_spinlock);
    }
}

esp_err_t __a0b_espidf_timer_INIT(esp_timer_cb_t callback, esp_timer_handle_t *out_handle)
{
    esp_timer_create_args_t config = {.dispatch_method = ESP_TIMER_ISR,
                                      .callback = callback};

    return esp_timer_create(&config, out_handle);
}