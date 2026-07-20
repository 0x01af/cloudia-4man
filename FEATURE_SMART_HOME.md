# Introduction
Home Assistant is the best smart home solution :muscle: - in my opinion :nerd_face:.

But, if your family enjoys the convenience of a smart home solution, than **availability** becomes crucial. In addition, **security** and **functionality** will be enhanced by additional software solutions. All of them have to be **maintained** and **operated**.

Unfortunately, Home Assistant doesn't feature any kind of high availability. And, HASS and HA Add-Ons doesn't simplify updating, maintaining, operating and hardening the whole environment.

Therefore, a lot of people started projects to provide a solution for Home Assistant High Availability or Home Assistant Operation Simplification:
- Home Assistant High Availability
  - with Docker Swarm - https://github.com/cvb941/HAHA
  - with Linbit DRBD, Pacemaker, Corosync, and Docker (published: June 18, 2024) - https://linbit.com/blog/home-assistant-high-availability/
  - with Kubernetes Distribution K3s - https://jaygould.co.uk/2024-01-01-setting-up-home-assistant-kubernetes-k3s/
  - with Kubernetes Distribution K3s - https://community.home-assistant.io/t/home-assistant-on-kubernetes/731745
  - with Kubernetes - https://blog.quadmeup.com/2025/04/07/how-to-run-home-assistant-in-kubernetes/
- Home Assistant Backup Strategies with scripts, crontab, and Home Assistant Backup - https://community.home-assistant.io/t/what-backup-strategy-when-running-home-assistant-in-docker/262539
- Home Assistant Data Housekeeping with filtering, and purging - https://community.home-assistant.io/t/how-to-keep-your-recorder-database-size-under-control/295795, https://community.home-assistant.io/t/taming-the-recorder/271932
- Home Assistant Data Analytics with VictoriaMetrics and Grafana - https://github.com/VictoriaMetrics-Community/homeassistant-addon-victoriametrics, https://www.influxdata.com/blog/how-integrate-gafana-home-assistant/
- Home Assistant Security with Web Application Firewall - https://www.adventurousway.com/blog/home-assistant-web-application-firewall
- Home Assistant Best Practices - https://community.home-assistant.io/t/the-home-assistant-cookbook-index/707144, https://community.home-assistant.io/t/home-assistant-best-practices/27630
- Home Assistant Enhancement with ZigBee2MQTT on Kubernetes Distribution K3s - https://jaygould.co.uk/2024-01-12-integrating-zigbee2mqtt-with-home-assistant-k3s-cluster/

**So do i!!!** :partying_face: \
**Why???** :roll_eyes: \
**Let's explain with a problem-solution-fit.** :handshake:

> [!TIP]
> Check out the community thread "High Availability in Home Assistant" about others opinions - https://community.home-assistant.io/t/high-availability-in-home-assistant/481358

## :handshake: Problem-Solution-Fit

| Problem | Cause | Solution |
| --- | --- | --- |
| High Availability | Home Assistant consists of two primary components:<br />1. the smart home control software (eg. dashboard with buttons, which switch a device on and off)<br />2. and the state database (eg. room temperature for last 10 days).<br />Both components have been implemented without redundancy support! | + Feature 1: Home Assistant will deployed on a K3s high-availability cluster (3 nodes, etcd-ha)<br/>+ Feature 2: Longhorn with 3 node for high-available storage |
| Maintainability |    |    |
| Web Application Security |   |  + Feature 3: Web Application Firewall Sidecar with OWASP security rules |
| Data Housekeeping | Home Assistant is primarly designed to control and display the current state of your smart home.<br />Longterm historical data are not in focus! | + Feature x: Home Assistant Configuration has been enhanced with database housekeeping (-> configuration_recorder.yaml). |


# Architecture

| Component | Software | Version | Ingress | Service | Container | Comments |
| ---  | ---  | ---  | ---  | ---  | ---  | ---  |
| Home Assistant | Home Assistant | v2026.1.0 | http[s]://home-assistant.home.local<br />allowlist: all | 8079: Sidecar-WAF<br />8080: Home Assistant Dashboard | home-assistant | _ |
| MQTT Broker | Mosquitto | 2.0.22 | http[s]://mqtt.home.local<br />- allowlist: private-only | 8081: Mosquitto Frontend<br />8883: Mosquitto MQTT Brocker (by tcp) | mosquitto | _ |
| Zigbee Gateway | Zigbee2MQTT | 2.7.2 | http[s]://zigbee2mqtt.home.local<br />- allowlist: private-only | 8081: Zigbee2MQTT Frontend | zigbee2mqtt | _ |
 
