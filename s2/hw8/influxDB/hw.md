Заполнение данными:

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "current,motor_id=M-1001,type=induction,load=high value=145.5"

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "current,motor_id=M-1001,type=induction,load=high value=151.2"

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "current,motor_id=M-1002,type=synchronous,load=medium value=98.7"

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "pressure,pipe_id=MP-01,section=main,zone=A value=4.2"

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "pressure,pipe_id=MP-01,section=main,zone=A value=4.8"

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "pressure,pipe_id=MP-02,section=backup,zone=B value=3.5"

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "temperature,sensor_id=T-01,area=workshop,type=industrial value=72.4"

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "temperature,sensor_id=T-01,area=workshop,type=industrial value=75.1"

curl -X POST "http://localhost:8086/api/v2/write?org=university&bucket=sensors&precision=s" \
-H "Authorization: Token my-super-token" \
-H "Content-Type: text/plain; charset=utf-8" \
--data-raw "temperature,sensor_id=T-02,area=warehouse,type=industrial value=61.9"


1. Просмотреть все данные за последние 30 минут
   from(bucket: "sensors")
   |> range(start: -30m)

2. Посмотреть измерения только одного датчика
   from(bucket: "sensors")
   |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
   |> filter(fn: (r) => r["_measurement"] == "current")
   |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
   |> yield(name: "mean")
3. Максимальное значение на одном датчике
   from(bucket: "sensors")
   |> range(start: -30m)
   |> filter(fn: (r) => r.motor_id == "M-1001")
   |> max()
4. Среднее значение на датчике
   from(bucket: "sensors")
   |> range(start: -30m)
   |> filter(fn: (r) => r.motor_id == "M-1001")
   |> mean()
5. Ток двигателя больше 140
   from(bucket: "sensors")
   |> range(start: -30m)
   |> filter(fn: (r) => r._measurement == "current")
   |> filter(fn: (r) => r._value > 140.0)
6. Давление больше 4
   from(bucket: "sensors")
   |> range(start: -30m)
   |> filter(fn: (r) => r._measurement == "pressure")
   |> filter(fn: (r) => r._value > 4.0)
7. Температура выше 70
   from(bucket: "sensors")
   |> range(start: -30m)
   |> filter(fn: (r) => r._measurement == "temperature")
   |> filter(fn: (r) => r._value > 70.0)
8. Запрос на агрегацию данных
   from(bucket: "sensors")
   |> range(start: -30m)
   |> group(columns: ["_measurement"])
   |> mean()
