<template>
    <div v-if="show" class="toast" :class="{ 'show': show }" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
            <strong class="me-auto">Notification</strong>
            <button type="button" class="btn-close" @click="hide"></button>
        </div>
        <div class="toast-body">
            {{ message }}
        </div>
    </div>
</template>

<script>
export default {
    props: {
        show: {
            type: Boolean,
            default: false
        },
        message: {
            type: String,
            default: ''
        }
    },
    watch: {
        show(newVal) {
            if (newVal) {
                setTimeout(() => {
                    this.hide();
                }, 3000); // Hide after 5 seconds
            }
        }
    },
    methods: {
        hide() {
            this.$emit('update:show', false);
        }
    }
};
</script>
