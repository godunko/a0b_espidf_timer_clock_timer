# ESP-IDF/Ada

## A0B Clock and Timer on ESP-IDF Timer

### `sdkconfig`

Implementation uses ISR callbacks, its support should be enabled explicitly in `sdkconfig` file:

```
CONFIG_ESP_TIMER_SUPPORTS_ISR_DISPATCH_METHOD=y
```
