
        // Server locations (x, y coordinates on SVG)
        const servers = {
            origin: { x: 400, y: 200, name: 'Origin Server' },
            edgeUS: { x: 300, y: 175, name: 'Edge Server 1' },
            edgeEU: { x: 375, y: 150, name: 'Edge Server 2' },
            edgeAsia: { x: 500, y: 190, name: 'Edge Server 3' },
            edgeAU: { x: 550, y: 250, name: 'Edge Server 4' },
            cdnUS: { x: 200, y: 150, name: 'CDN New York' },
            cdnEU: { x: 350, y: 100, name: 'CDN London' },
            cdnAsia: { x: 600, y: 180, name: 'CDN Singapore' },
            cdnAU: { x: 650, y: 300, name: 'CDN Sydney' }
        };

        // User locations with their corresponding CDN and edge servers
        const userLocations = {
            us: { 
                x: 200, 
                y: 150, 
                cdn: 'cdnUS',
                edge: 'edgeUS'
            },
            eu: { 
                x: 350, 
                y: 100, 
                cdn: 'cdnEU',
                edge: 'edgeEU'
            },
            asia: { 
                x: 600, 
                y: 180, 
                cdn: 'cdnAsia',
                edge: 'edgeAsia'
            },
            au: { 
                x: 650, 
                y: 300, 
                cdn: 'cdnAU',
                edge: 'edgeAU'
            }
        };

        let isAnimating = false;

        // DOM Elements
        const userSelect = document.getElementById('userSelect');
        const withoutCDNBtn = document.getElementById('withoutCDN');
        const withCDNBtn = document.getElementById('withCDN');
        const resetBtn = document.getElementById('reset');
        const userCircle = document.getElementById('user');
        const userLabel = document.getElementById('userLabel');
        const connectionLine1 = document.getElementById('connectionLine1');
        const connectionLine2 = document.getElementById('connectionLine2');
        const dataPacket = document.getElementById('dataPacket');
        const distanceSpan = document.getElementById('distance');
        const latencySpan = document.getElementById('latency');
        const serverSpan = document.getElementById('server');
        const statusSpan = document.getElementById('status');

        // Update user position based on selection
        function updateUserPosition() {
            const location = userLocations[userSelect.value];
            userCircle.setAttribute('cx', location.x);
            userCircle.setAttribute('cy', location.y);
            userLabel.setAttribute('x', location.x);
            userLabel.setAttribute('y', location.y + 40);
            resetStats();
        }

        // Calculate distance between two points
        function calculateDistance(x1, y1, x2, y2) {
            return Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
        }

        // Animate data packet
        function animatePacket(fromX, fromY, toX, toY, duration, callback) {
            const startTime = Date.now();
            dataPacket.style.display = 'block';
            
            function animate() {
                const elapsed = Date.now() - startTime;
                const progress = Math.min(elapsed / duration, 1);
                
                const currentX = fromX + (toX - fromX) * progress;
                const currentY = fromY + (toY - fromY) * progress;
                
                dataPacket.setAttribute('cx', currentX);
                dataPacket.setAttribute('cy', currentY);
                
                if (progress < 1) {
                    requestAnimationFrame(animate);
                } else {
                    if (callback) callback();
                }
            }
            
            animate();
        }

        // Request without CDN (goes through edge server to origin)
        function requestWithoutCDN() {
            if (isAnimating) return;
            isAnimating = true;
            
            const userLoc = userLocations[userSelect.value];
            const edgeServer = servers[userLoc.edge];
            const originServer = servers.origin;
            
            // Show connection lines
            connectionLine1.setAttribute('x1', userLoc.x);
            connectionLine1.setAttribute('y1', userLoc.y);
            connectionLine1.setAttribute('x2', edgeServer.x);
            connectionLine1.setAttribute('y2', edgeServer.y);
            connectionLine1.style.display = 'block';
            
            connectionLine2.setAttribute('x1', edgeServer.x);
            connectionLine2.setAttribute('y1', edgeServer.y);
            connectionLine2.setAttribute('x2', originServer.x);
            connectionLine2.setAttribute('y2', originServer.y);
            connectionLine2.style.display = 'block';
            
            // Calculate stats
            const distanceToEdge = calculateDistance(userLoc.x, userLoc.y, edgeServer.x, edgeServer.y);
            const distanceEdgeToOrigin = calculateDistance(edgeServer.x, edgeServer.y, originServer.x, originServer.y);
            const totalDistance = distanceToEdge + distanceEdgeToOrigin;
            const latency = Math.round(totalDistance * 1.8 + 80); // Base latency + distance factor
            
            statusSpan.textContent = 'Requesting...';
            statusSpan.style.color = '#ffa94d';
            disableButtons(true);
            
            // Animate: User -> Edge -> Origin -> Edge -> User
            animatePacket(userLoc.x, userLoc.y, edgeServer.x, edgeServer.y, 1200, () => {
                animatePacket(edgeServer.x, edgeServer.y, originServer.x, originServer.y, 1500, () => {
                    animatePacket(originServer.x, originServer.y, edgeServer.x, edgeServer.y, 1500, () => {
                        animatePacket(edgeServer.x, edgeServer.y, userLoc.x, userLoc.y, 1200, () => {
                            connectionLine1.style.display = 'none';
                            connectionLine2.style.display = 'none';
                            dataPacket.style.display = 'none';
                            distanceSpan.textContent = `${Math.round(totalDistance * 8)} km`;
                            latencySpan.textContent = `${latency} ms`;
                            serverSpan.textContent = `User → Edge → Origin`;
                            statusSpan.textContent = 'Complete';
                            statusSpan.style.color = '#51cf66';
                            isAnimating = false;
                            disableButtons(false);
                        });
                    });
                });
            });
        }

        // Request with CDN (direct to nearest CDN)
        function requestWithCDN() {
            if (isAnimating) return;
            isAnimating = true;
            
            const userLoc = userLocations[userSelect.value];
            const cdnServer = servers[userLoc.cdn];
            
            // Show connection line to CDN with green color
            connectionLine1.setAttribute('x1', userLoc.x);
            connectionLine1.setAttribute('y1', userLoc.y);
            connectionLine1.setAttribute('x2', cdnServer.x);
            connectionLine1.setAttribute('y2', cdnServer.y);
            connectionLine1.style.display = 'block';
            connectionLine1.style.stroke = '#51cf66'; // Green color for CDN path
            connectionLine2.style.display = 'none';
            
            // Change packet color to green for CDN
            dataPacket.classList.add('cdn-packet');
            
            // Calculate stats
            const distance = calculateDistance(userLoc.x, userLoc.y, cdnServer.x, cdnServer.y);
            const latency = Math.round(distance * 0.8 + 15); // Much lower latency
            
            statusSpan.textContent = 'Requesting from CDN...';
            statusSpan.style.color = '#51cf66';
            disableButtons(true);
            
            // Show the path immediately
            dataPacket.style.display = 'block';
            
            // Animate to CDN and back (much faster!)
            animatePacket(userLoc.x, userLoc.y, cdnServer.x, cdnServer.y, 600, () => {
                // Packet reached CDN, now returning
                statusSpan.textContent = 'Receiving from CDN...';
                animatePacket(cdnServer.x, cdnServer.y, userLoc.x, userLoc.y, 600, () => {
                    // Keep line visible for a moment to show the path
                    setTimeout(() => {
                        connectionLine1.style.display = 'none';
                        connectionLine1.style.stroke = '#ffa94d'; // Reset to default color
                        dataPacket.style.display = 'none';
                        dataPacket.classList.remove('cdn-packet');
                    }, 500);
                    
                    distanceSpan.textContent = `${Math.round(distance * 8)} km`;
                    latencySpan.textContent = `${latency} ms`;
                    serverSpan.textContent = `User → ${cdnServer.name}`;
                    statusSpan.textContent = 'Complete (Cached!)';
                    statusSpan.style.color = '#51cf66';
                    isAnimating = false;
                    disableButtons(false);
                });
            });
        }

        // Reset simulation
        function resetSimulation() {
            connectionLine1.style.display = 'none';
            connectionLine2.style.display = 'none';
            dataPacket.style.display = 'none';
            resetStats();
        }

        // Reset stats display
        function resetStats() {
            distanceSpan.textContent = '-';
            latencySpan.textContent = '-';
            serverSpan.textContent = '-';
            statusSpan.textContent = 'Ready';
            statusSpan.style.color = '#667eea';
        }

        // Disable/enable buttons during animation
        function disableButtons(disabled) {
            withoutCDNBtn.disabled = disabled;
            withCDNBtn.disabled = disabled;
            userSelect.disabled = disabled;
        }

        // Event listeners
        userSelect.addEventListener('change', updateUserPosition);
        withoutCDNBtn.addEventListener('click', requestWithoutCDN);
        withCDNBtn.addEventListener('click', requestWithCDN);
        resetBtn.addEventListener('click', resetSimulation);

        // Initialize
        updateUserPosition();