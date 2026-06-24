# thought at 19/06/2026
# written at 24/06/2026

# most of it is g enerated with gemini

import math
import turtle

class Particle:
    def __init__(self, x: float, y: float, mass: float, radius: float, name: str):
        self.x = x
        self.y = y
        self.mass = mass
        self.radius = radius
        self.name = name

# Original masses from your setup
particles = [
    Particle(50, 50, 15000, 15, "Star Alpha"),
    Particle(150, 0, 25000, 20, "Star Beta"),
]

# --- YOUR ORIGINAL AETHER FUNCTIONS ---
DIST_UNIT = 1_000_000  # 1x = 1K km

def rigidity_at(x, y):
    return 9 * 10**16  # uniform rigidity

def density_at(x, y):
    density = 1.0

    for particle in particles:
        px = particle.x
        py = particle.y
        pr = particle.radius
        pm = particle.mass

        d = math.sqrt((x - px)**2 + (y - py)**2)
        if (d < pr):
            d = pr
        density += pm / (d**2 * DIST_UNIT**2)

    return density

def speed_at(x, y):
    return math.sqrt(rigidity_at(x, y) / density_at(x, y))


# --- ACTUAL DRAWING ---
screen = turtle.Screen()
turtle.clearscreen()
screen.setup(800, 600)
screen.tracer(0)
screen.bgcolor("#111827")

def draw_particles():
    drawer = turtle.Turtle()
    drawer.hideturtle()
    drawer.penup()

    for p in particles:
        # Gravity aura
        drawer.goto(p.x, p.y - (p.radius * 2))
        drawer.color("#1e2d5a")
        drawer.begin_fill()
        drawer.circle(p.radius * 2)
        drawer.end_fill()

        # Star core
        drawer.goto(p.x, p.y - p.radius)
        drawer.color("#4a90e2")
        drawer.begin_fill()
        drawer.circle(p.radius)
        drawer.end_fill()

        # Star name
        drawer.goto(p.x, p.y - p.radius - 20)
        drawer.color("white")
        drawer.write(p.name, align="center", font=("Arial", 10, "bold"))

def draw_ray(drawer, start_y):
    drawer.penup()
    rx, ry = -400, start_y
    drawer.goto(rx, ry)
    drawer.pendown()
    drawer.color("#f59e0b")

    angle = 0.0
    step = 4.0

    for _ in range(250):
        # 1. Sample your speed_at function slightly left and right of the ray path
        delta = 2.0
        lx  = rx + delta * math.cos(angle + math.pi/2)
        ly  = ry + delta * math.sin(angle + math.pi/2)
        r2x = rx + delta * math.cos(angle - math.pi/2)
        r2y = ry + delta * math.sin(angle - math.pi/2)

        # 2. Calculate Refractive Index (n = c / v) using your physics equations
        # We use the theoretical baseline vacuum speed (3 * 10^8) as reference
        c = 3.0 * 10**8
        n_left = c / speed_at(lx, ly)
        n_right = c / speed_at(r2x, r2y)

        # 3. Wavefront drags toward the slower, denser region (Snell's Law)
        # Scaled up to register micro-decimal changes on a pixel grid
        refraction_gradient = (n_left - n_right) * 1.8 * 10**11
        angle += refraction_gradient

        # 4. March forward
        rx += step * math.cos(angle)
        ry += step * math.sin(angle)
        drawer.goto(rx, ry)

        # Boundary checks
        if (abs(rx) >= 400) or (abs(ry) > 300):
            break

        # Collision checks
        hit_star = False
        for p in particles:
            if math.sqrt((rx - p.x)**2 + (ry - p.y)**2) <= p.radius:
                hit_star = True
                break
        if hit_star:
            break

def draw_rays():
    drawer = turtle.Turtle()
    drawer.hideturtle()

    for start_y in range(-200, 250, 20):
        draw_ray(drawer, start_y)

# Execute everything
draw_particles()
draw_rays()
screen.update()
turtle.done()


###############
# old code
import math
import turtle

# --- YOUR AETHER MATH ENGINE ---
AETHER_MODULUS = 9 * 10**16

# Let's put a couple of heavy planets in space
particles = [
    {"x": 50, "y": 50, "m": 15000, "name": "Star Alpha"},
    {"x": -100, "y": -20, "m": 25000, "name": "Star Beta"}
]

def p_at(x, y):
    density = 1
    for p in particles:
        dist = math.sqrt((x - p["x"])**2 + (y - p["y"])**2)
        if dist < 10:
            dist = 10
        density += (p["m"] / (dist**2))
    return density

def v_at(x, y):
    return math.sqrt(AETHER_MODULUS / p_at(x, y))

# --- CPU-SAFE TURTLE GRAPHICS UI ---
# Set up a dark canvas space
screen = turtle.Screen()
screen.setup(800, 600)
screen.bgcolor("#0d0e15")
screen.title("GPU-Free Luminaferous Aether Ray Tracer")

# Turn off animation updates temporarily so it draws instantly
screen.tracer(0)

# Draw the background stars/planets
marker = turtle.Turtle()
marker.hideturtle()
marker.penup()

for p in particles:
    # Draw gravity aura
    marker.goto(p["x"], p["y"] - 30)
    marker.color("#1e2d5a")
    marker.begin_fill()
    marker.circle(30)
    marker.end_fill()

    # Draw core
    marker.goto(p["x"], p["y"] - 10)
    marker.color("#4a90e2")
    marker.begin_fill()
    marker.circle(10)
    marker.end_fill()

    # Draw text label
    marker.goto(p["x"], p["y"] - 50)
    marker.color("white")
    marker.write(p["name"], align="center", font=("Arial", 10, "normal"))

# Set up the light ray pencil
ray = turtle.Turtle()
ray.hideturtle()
ray.speed(0)
ray.width(3)
ray.color("#ccff00") # Neon yellow laser

# Starting light beam conditions
x, y = -350, 0
angle = math.radians(5) # Angle pointing slightly up
vx, vy = math.cos(angle), math.sin(angle)
step_size = 4

ray.penup()
ray.goto(x, y)
ray.pendown()

# Trace the beam across space using your derivatives
for _ in range(250):
    current_v = v_at(x, y)

    # Numerical derivative (Central Difference)
    delta = 1.0
    v_dx = (v_at(x + delta, y) - v_at(x - delta, y)) / (2 * delta)
    v_dy = (v_at(x, y + delta) - v_at(x, y - delta)) / (2 * delta)

    # Bend the trajectory vector toward denser aether
    vx -= v_dx * (step_size / current_v)
    vy -= v_dy * (step_size / current_v)

    # Keep the vector velocity locked to normal proportions
    mag = math.sqrt(vx**2 + vy**2)
    if mag != 0:
        vx, vy = vx / mag, vy / mag

    # Calculate next step
    x += vx * step_size
    y += vy * step_size

    # Draw step segment
    ray.goto(x, y)

    if abs(x) > 400 or abs(y) > 300:
        break

# Push everything to the screen at once
screen.update()

# Keeps the window open safely without using CPU loops
print("Render complete! Enjoy your vintage-safe physics graphics.")
turtle.done()

## above's turtle is entirely generated by gemini
