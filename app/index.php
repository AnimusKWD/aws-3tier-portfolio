<?php
// =============================================================
// index.php - Application PHP AWS 3-Tier Architecture
// Auteur : AnimusK7 (Decardo Koumous Wouile)
// =============================================================

// Configuration de la connexion RDS
$db_host = getenv('DB_HOST') ?: 'your-rds-endpoint.amazonaws.com';
$db_name = getenv('DB_NAME') ?: 'appdb';
$db_user = getenv('DB_USER') ?: 'admin';
$db_pass = getenv('DB_PASS') ?: 'your-password';

// Tentative de connexion a RDS
$conn = null;
$db_status = 'Disconnected';
$db_class = 'status-error';

try {
    $conn = new PDO(
        "mysql:host=$db_host;dbname=$db_name;charset=utf8",
        $db_user,
        $db_pass,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
    $db_status = 'Connected to RDS MySQL';
    $db_class = 'status-ok';
} catch (PDOException $e) {
    $db_status = 'DB Error: ' . $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS 3-Tier Architecture</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #0d1117;
            color: #e6edf3;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            max-width: 800px;
            width: 90%;
            background: #161b22;
            border: 1px solid #30363d;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
        }
        .logo { font-size: 3rem; margin-bottom: 10px; }
        h1 { font-size: 1.8rem; color: #58a6ff; margin-bottom: 8px; }
        .subtitle { color: #8b949e; margin-bottom: 30px; font-size: 0.95rem; }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 30px;
        }
        .card {
            background: #0d1117;
            border: 1px solid #30363d;
            border-radius: 8px;
            padding: 20px 12px;
        }
        .card-icon { font-size: 1.8rem; margin-bottom: 8px; }
        .card-title { font-size: 0.85rem; font-weight: 600; color: #58a6ff; }
        .card-desc { font-size: 0.75rem; color: #8b949e; margin-top: 4px; }
        .status-box {
            border-radius: 8px;
            padding: 14px 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .status-ok { background: #1a3a2a; border: 1px solid #238636; color: #3fb950; }
        .status-error { background: #3a1a1a; border: 1px solid #da3633; color: #f85149; }
        .info {
            font-size: 0.8rem;
            color: #8b949e;
            border-top: 1px solid #30363d;
            padding-top: 16px;
        }
        .info span { color: #58a6ff; }
    </style>
</head>
<body>
<div class="container">
    <div class="logo">&#x2601;</div>
    <h1>AWS 3-Tier Architecture</h1>
    <p class="subtitle">Deployed by AnimusK7 &mdash; Cloud &amp; DevOps Portfolio</p>

    <div class="status-box <?php echo $db_class; ?>">
        &#x1F4BE; Database : <?php echo htmlspecialchars($db_status); ?>
    </div>

    <div class="cards">
        <div class="card">
            <div class="card-icon">&#x1F310;</div>
            <div class="card-title">VPC</div>
            <div class="card-desc">10.0.0.0/16<br>Public + Private Subnets</div>
        </div>
        <div class="card">
            <div class="card-icon">&#x2696;</div>
            <div class="card-title">Load Balancer</div>
            <div class="card-desc">ALB distributing<br>HTTP traffic</div>
        </div>
        <div class="card">
            <div class="card-icon">&#x1F5A5;</div>
            <div class="card-title">EC2</div>
            <div class="card-desc">Amazon Linux 2<br>Apache + PHP</div>
        </div>
        <div class="card">
            <div class="card-icon">&#x1F4C0;</div>
            <div class="card-title">RDS MySQL</div>
            <div class="card-desc">Private subnet<br>Managed database</div>
        </div>
    </div>

    <div class="info">
        Server IP: <span><?php echo htmlspecialchars($_SERVER['SERVER_ADDR'] ?? 'N/A'); ?></span>
        &nbsp;&nbsp;|&nbsp;&nbsp;
        PHP: <span><?php echo PHP_VERSION; ?></span>
        &nbsp;&nbsp;|&nbsp;&nbsp;
        Host: <span><?php echo htmlspecialchars(gethostname()); ?></span>
    </div>
</div>
</body>
</html>
