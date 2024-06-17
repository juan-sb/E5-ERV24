# uart_peripheral_with_fifo

## Mapeo de Direcciones

| Dirección | Funcionalidad                                   |
| --------- | ----------------------------------------------- |
| 0x00      | Escritura a Tx (FIFO) (w, reads a zero)         |
| 0x01      | Lectura de Rx (FIFO) (r, writing has no effect) |
| 0x02      | Registro de control y estado (r/w)              |

## Registro de Control y Estado (8 bits)

| Bit | Función                                     |
| --- | ------------------------------------------- |
| 0   | Tx Enable (r/w)                             |
| 1   | Rx Enable (r/w)                             |
| 2   | Tx FIFO Clear (r/w, reads as zero)          |
| 3   | Rx FIFO Clear (r/w, reads as zero)          |
| 4   | Tx Ready (r/w, must be cleared by software) |
| 5   | Rx Ready (r/w, must be cleared by software) |
| 6-7 | Reservado                                   |