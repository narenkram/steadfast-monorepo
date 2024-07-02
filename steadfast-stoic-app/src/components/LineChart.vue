<template>
    <canvas ref="lineChart"></canvas>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { Chart, LineController, LineElement, PointElement, CategoryScale, LinearScale, Title, Tooltip, Legend } from 'chart.js';

Chart.register(LineController, LineElement, PointElement, CategoryScale, LinearScale, Title, Tooltip, Legend);

const props = defineProps({
    profitData: {
        type: Array,
        required: true
    }
});

const lineChart = ref(null);
let chartInstance = null;
let accumulatedProfitData = [0]; // Initialize with a starting value of zero

// Function to generate hourly labels from 9:15 AM to 3:30 PM
const generateFullDayLabels = () => {
    const labels = [];
    let currentTime = new Date();
    currentTime.setHours(9, 15, 0, 0); // Set to 9:15 AM

    while (currentTime.getHours() < 15 || (currentTime.getHours() === 15 && currentTime.getMinutes() <= 30)) {
        labels.push(currentTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }));
        currentTime.setMinutes(currentTime.getMinutes() + 60); // Increment by 1 hour
    }

    return labels;
};

// Function to generate labels up to the current time
const generateLabelsUpToNow = () => {
    const labels = [];
    let currentTime = new Date();
    currentTime.setHours(9, 15, 0, 0); // Set to 9:15 AM

    const now = new Date();

    while (currentTime <= now) {
        labels.push(currentTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }));
        currentTime.setMinutes(currentTime.getMinutes() + 60); // Increment by 1 hour
    }

    return labels;
};

onMounted(() => {
    console.log('Initial profitData:', props.profitData); // Debugging line

    const ctx = lineChart.value.getContext('2d');
    chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: generateFullDayLabels(), // Use the full day labels
            datasets: [{
                label: 'MTM Profit',
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                borderColor: 'rgb(255, 99, 132)',
                data: accumulatedProfitData, // Use the accumulated data
                fill: false,
                tension: 0.1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: true,
                    position: 'top'
                },
                title: {
                    display: true,
                    text: 'MTM Profit Over Time'
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const label = context.dataset.label || '';
                            const value = context.raw;
                            const time = new Date().toLocaleTimeString();
                            return `${label}: ${value} (Current Time: ${time})`;
                        }
                    }
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Time'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Profit / Loss'
                    }
                }
            }
        }
    });
});

watch(() => props.profitData, (newData) => {
    console.log('Updated profitData:', newData); // Debugging line

    if (chartInstance) {
        accumulatedProfitData.push(newData[0]); // Accumulate the new data point

        // Fill the remaining time slots with null
        const fullDayLabels = generateFullDayLabels();
        const labelsUpToNow = generateLabelsUpToNow();
        const filledData = fullDayLabels.map(label => {
            const index = labelsUpToNow.indexOf(label);
            return index !== -1 ? accumulatedProfitData[index] : null;
        });

        chartInstance.data.labels = fullDayLabels; // Update labels to full day
        chartInstance.data.datasets[0].data = filledData; // Update data with filled data
        chartInstance.update();
    }
});
</script>
