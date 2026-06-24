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
