## Monitoring - Prometheus, Grafana, AlertManager

### Task

1) Використовуючи Docker, необхідно підняти:
    - Стек моніторингу (Prometheus, Grafana, AlertManager)
    - Експортери, які необхідні для виконання завдання
2) Налаштувати моніторинг потрібно для:
    - працюючих контейнерів
    - системних метрик (CPU, Оперативна памʼять і тп)
3) Для відповідних експортерів, підключити дашборди
    - використовуючи готові із Grafana спільноти.
4) Налаштувати алерти, які будуть відправлятися до Telegram коли:
    - кількість вільного місця < 15%
    - завантаженість CPU > 80%
    - хоча б один із таргетів, з яких прометеус збирає метрики, не доступний

#### Варіант 1 - var_01

- Створення стеку Prometheus, Grafana, AlertManager
- Додавання datasource та dashboard вручну

#### Варіант 2 - var_02

- Створення стеку Prometheus, Grafana, AlertManager
- Додавання datasource автоматично
- Додавання node-exporter dashboard автоматично

#### Створення Telegram бота:

- Відкрийте Telegram і знайдіть @BotFather
- Відправте команду /newbot
- Дотримуйтесь інструкцій для створення бота
- Збережіть отриманий токен бота
- Створіть групу в Telegram
- Додайте бота до групи
- Відправте повідомлення в групу
- Відвідайте URL: https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
- Знайдіть chat_id в JSON відповіді

### HOW TO

```shell
cd var_02
```

```shell
docker compose up -d
```

Доступ до інтерфейсів:

```shell
- Prometheus: http://your-ip:9090
- Grafana: http://your-ip:3000 (login: admin, password: admin)
- AlertManager: http://your-ip:9093
```

Налаштування дашбордів у Grafana:

```shell
- Увійдіть в Grafana
- Перейдіть до "Dashboards" -> "Import"
- Імпортуйте наступні ID дашбордів:
  - Node Exporter: 1860 (за необхідності)
  - cAdvisor: 14282
  - Docker: 893
```

Перевірка алертів:

```shell
Перевірте статус таргетів у Prometheus

- http://your-ip:9090/targets

Перевірте налаштовані правила алертів

- http://your-ip:9090/alerts
```

Перевірка AlertManager:

```shell
Перевірте конфігурацію

- http://your-ip:9093/#/status

Перевірте активні алерти

- http://your-ip:9093/#/alerts
```

**Корисні команди для діагностики:**

```shell
Перевірка логів конкретного сервісу

- docker compose logs prometheus
- docker compose logs alertmanager

Перезапуск окремого сервісу

- docker compose restart prometheus
- docker compose restart alertmanager
```

Тестування

**Використання CPU > 80% протягом 5 хвилин**

Три варіанти[^1]

```shell
# Створіть високе навантаження на CPU за допомогою stress-ng
docker run --rm -it containerstack/cpustress --cpu 4 --cpu-method all --timeout 300
-----------------------------------------------------------------
docker run --rm -it busybox sh -c 'while true; do yes > /dev/null; done'
-----------------------------------------------------------------
docker run --rm -it alpine sh
apk add stress-ng
stress-ng --cpu 4 --cpu-method all --timeout 300
```

**Вільне місце на диску < 15%**

Два варіанти[^2]
```shell
# Створюємо контейнер без --rm щоб він не видалявся автоматично
docker run -d --name space-test busybox sh -c 'dd if=/dev/zero of=/tmp/largefile bs=1M count=10000; sleep 400'	

Тут ми:
Запускаємо контейнер в фоні (-d)
Даємо йому ім'я (--name space-test)
Створюємо великий файл
Додаємо sleep 400 (6.6 хвилин) щоб контейнер продовжував працювати

Це дасть вам достатньо часу щоб:
Файл зайняв місце на диску
Система моніторингу виявила нестачу місця
Спрацював Alert
Ви змогли перевірити правильність роботи оповіщення

Після тестування ви можете видалити контейнер:
docker rm -f space-test
Також варто перевірити поточне використання диску командою:
bashCopydf -h
-----------------------------------------------------------------
# Створює великий файл - як на мене більш швидкий спосіб
dd if=/dev/zero of=bigfile bs=1M count=1000
```

**Якщо будь-який з таргетів недоступний протягом 5 хвилин**

```shell
docker stop CONTAINER_NAME
чекаємо деякий час 
docker start CONTAINER_NAME
або 
docker cimpose restart SERVICE_NAME
```

[^1]: Працює тільки для Intell процесорів. Для ARM не працює.
[^2]: Файл буде створено локально - його необхідно буде видалити вручну. 
