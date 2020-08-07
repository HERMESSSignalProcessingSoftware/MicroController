###  Testplan
#### ADC
| Testcase    | Description   | Result |
| ------------    | --------------------   | --------------|
| 1    | Configuration    |    |
| 1.1   | Speed    |    |
| 1.2 | Setting speed to 2ksp |    |
| 1.3    | 	Setting Resolution to 16 bit  |     |
| 2     | Start of convertion  |    |
| 3 | Interrupt triggered |   |
| 4    | Read result    |    |

#### MCU 
| Testcase    | Beschreibung   | Ergebnis |
| ------------    | --------------------   | --------------|
| 1     | Data handling ADC |     |
| 2    | compression |    |
| 3    | Packet building |     |
| 3.1   | Checksums |    |
| 3.2    | Checkup packages |    |
| 4    | Datatransmission telemetry |     |
| 5    | Mutlithreading     |     |
| 5.1    | No deadlocks |     |
| 6    | DAPI Functions |    |
| 6.1    | Corrupt commands |     |
| 6.2    | Inconsistent commands |     |
| 6.3     |Settings MCU|   |
| 7 | Memory | |

#### Memory 
| Testcase    | Beschreibung   | Ergebnis   |
| ------------    | --------------------   | --------------|
| 1     | Memory configuration |    |
| 2    | Data handling |    |
| 2.1    | Write data |    |
| 2.2     | Read data |    |
| 2.3     | Remove data |     |

#### DAPI 
| Testcase    | Beschreibung   | Ergebnis   |
| ------------    | --------------------   | --------------|
| 1    | Access MCU |     |
| 2    | Run systemtests |    |
| 3    | Data transfer |    |
| 3.1    | Transfer of valid data |    |
| 3.2    | Transfer of invalid data |    |
| 4   | Usability |    |
