# 🌐 Content Delivery Network (CDN) Simulation

## 📘 Project Overview
This project simulates how a **Content Delivery Network (CDN)** works to deliver web content efficiently from the nearest server to the user.  
It demonstrates the reduction in **latency** and improvement in **performance** when content is delivered through edge servers instead of a central origin server.

---

## 🎯 Objectives
- To visualize the working of a CDN.
- To simulate latency differences between origin and edge servers.
- To understand how CDN improves user experience by reducing response time.
- To demonstrate content distribution using frontend technologies.

---

## 💡 Features
- Interactive map showing **Origin Server** and **Edge Servers**.  
- Click-based simulation to test latency from different user locations.  
- Real-time display of **latency** and **status** for each request.  
- Visual animations to show data flow between servers and users.  
- Optional display of distances between nodes (configurable in JS).

---

## 🧩 How It Works
1. The user selects or clicks on a location (representing a client).  
2. The system checks the **nearest CDN edge server**.  
3. It calculates and displays the **latency time** between client and server.  
4. If no edge server is close, the request is routed to the **origin server**.  
5. The simulation shows how CDNs reduce load time and improve speed.

